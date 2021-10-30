import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class IncidesLogic extends GetxController {
  final _dataRepository = Get.find<DbRepository>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final scrollController = ScrollController();
  TypeInciModel? _typeInciModel;
  TypeInci? _typeInci;
  TypeInci? _typeInciNew;
  IncidencesModel? _incidencesModel;
  Uint8List? _bytes;
  String _nameFile = 'Seleccionar...';
  int _index = 0;
  final int _limit = 25;

  TypeInciModel? get typeInciModel => _typeInciModel;

  TypeInci? get typeInci => _typeInci;

  TypeInci? get typeInciNew => _typeInciNew;

  IncidencesModel? get incidencesModel => _incidencesModel;

  @override
  void onReady() {
    _getTypeInci();
    _setupScrollController();
    super.onReady();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _getTypeInci() async {
    _typeInciModel = await _dataRepository.typeInci();
    if (typeInciModel != null) {
      _typeInciModel!.typeInci.insert(0, TypeInci(id: 0, name: 'Todos'));
      _typeInci = typeInciModel!.typeInci[0];
      update(['typeIncis']);
      _getIncids(typeInci!.id, false);
    }
  }

  void _getIncids(int idTypeInci, bool reload) async {
    if (reload) {
      _incidencesModel =
          IncidencesModel(error: false, mensaje: '', total: 0, incidences: []);
      _index = 0;
    }
    IncidencesModel oldIncidencesModel;
    IncidencesModel newIncidencesModel;
    if (incidencesModel != null) {
      oldIncidencesModel = incidencesModel!;
    } else {
      oldIncidencesModel =
          IncidencesModel(error: false, mensaje: '', total: 0, incidences: []);
    }
    if (oldIncidencesModel.total >= _index) {
      final newInc = await _dataRepository.getIncidences(map: {
        'idTypeIncid': idTypeInci == 0 ? '' : idTypeInci.toString(),
        'index': _index.toString(),
        'limit': _limit.toString()
      });
      if (newInc != null) {
        newIncidencesModel = newInc;
      } else {
        newIncidencesModel = IncidencesModel(
            error: false, mensaje: '', total: 0, incidences: []);
      }
      _index = _index + _limit + 1;
    } else {
      newIncidencesModel =
          IncidencesModel(error: false, mensaje: '', total: 0, incidences: []);
    }
    _incidencesModel = oldIncidencesModel;
    _incidencesModel!.total = newIncidencesModel.total;
    _incidencesModel!.incidences.addAll(newIncidencesModel.incidences);
    update(['incidences']);
  }

  void selectTypeInci(TypeInci data) {
    _typeInci = data;
    update(['typeIncis']);
    _getIncids(data.id, true);
  }

  void selectTypeInciNew(TypeInci data) {
    if (data.id != 0) {
      _typeInciNew = data;
      update(['typeIncisNew']);
    } else {
      _snackBar(Colors.red, 'ERROR', 'Seleccione otro tipo de incidente');
    }
  }

  void _snackBar(Color color, String title, String body) {
    Get.snackbar(
      title,
      body,
      colorText: color,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      margin: const EdgeInsets.all(15),
    );
  }

  void _filePicker() async {
    final pdfPicked = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
    if (pdfPicked != null) {
      _bytes = pdfPicked.files.single.bytes!;
      //_base64PDF = base64Encode(bytes);
      _nameFile = pdfPicked.files.single.name;
      update(['picked']);
    }
  }

  String? isNotEmpty(String? text) {
    if (text != null) if (text.isNotEmpty) return null;
    return 'Ingrese datos';
  }

  void toBack() {
    Get.rootDelegate.popRoute();
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        _getIncids(typeInci!.id, false);
      }
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        _getIncids(typeInci!.id, true);
      }
    });
  }

  void newIncid(String action, {int idIncid = 0}) {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 400,
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                       Center(
                        child: Text(
                          '${action == 'new' ? 'Nuevo' : 'Actualizar'} Incidente',
                          style:const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              child: const Icon(Icons.close, color: Colors.red),
                              onTap: toBack),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Título',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    controller: _titleCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Título',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red))),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Descripciòn',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _descCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Descripciòn',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red))),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tipo de incidente',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  GetBuilder<IncidesLogic>(
                      id: 'typeIncisNew',
                      builder: (_) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<TypeInci>(
                            isExpanded: true,
                            value: typeInciNew,
                            hint: const Text('Tipo de incidente'),
                            underline: const SizedBox(),
                            items: typeInciModel!.typeInci
                                .map((e) => DropdownMenuItem<TypeInci>(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (value) =>
                                selectTypeInciNew(value as TypeInci),
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  const Text(
                    'Seleccione su PDF',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  GetBuilder<IncidesLogic>(
                      id: 'picked',
                      builder: (_) {
                        final name = _._nameFile;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _filePicker,
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black)),
                                height: 50,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(name))),
                          ),
                        );
                      }),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () => action == 'new'
                            ? createIncidence()
                            : _updateIncid(idIncid),
                        child: const Text('Guardar')),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void createIncidence() async {
    if (_formKey.currentState!.validate()) {
      if (typeInciNew != null) {
        if (AuthService.to.userId != null) {
          if (_bytes != null) {
            _dialogLoading();
            final incidence = await _dataRepository.createIncidence(map: {
              'title': _titleCtrl.text,
              'description': _descCtrl.text,
              'idTypeIncid': typeInciNew!.id.toString(),
              'idUser': AuthService.to.userId.toString(),
              'pdf': base64Encode(_bytes!),
            }); Get.back();
            if (incidence != null) {
              _bytes = null;
              _titleCtrl.clear();
              _descCtrl.clear();
              _getIncids(typeInci!.id, true);
              Get.back();
            } else {
              _snackBar(Colors.red, 'ERROR', 'Error al crear la incidencia');
            }
          } else {
            _snackBar(Colors.red, 'ERROR', 'Seleccione un archivo PDF');
          }
        } else {
          _snackBar(Colors.red, 'ERROR',
              'No tienes permisos para realizar esta acción');
        }
      } else {
        _snackBar(Colors.red, 'ERROR', 'Seleccione un tipo de incidente');
      }
    }
  }

  void toPDF(String pdfUrl) async {
    await canLaunch(pdfUrl)
        ? await launch(pdfUrl)
        : throw 'Could not launch $pdfUrl';
  }

  void selPopup(String value, Incidence incidence) {
    switch (value) {
      case 'detail':
        Get.rootDelegate
            .toNamed(Routes.incidesDetails(incidence.idIncid.toString()));
        break;
      case 'pdf':
        toPDF(incidence.pdfUrl);
        break;
      case 'edit':
        if (incidence.name == AuthService.to.name &&
                incidence.lastName == AuthService.to.lastName ||
            AuthService.to.role == 'admin') {
          _titleCtrl.text = incidence.title;
          _descCtrl.text = incidence.description;
          newIncid('edit', idIncid: incidence.idIncid);
        } else {
          _snackBar(Colors.red, 'ERROR',
              'No tienes permisos para realizar esta acción');
        }
        break;
      default:
        break;
    }
  }
  void _dialogLoading() {
    Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }
  void _updateIncid(int idIncid) async {
    if (_formKey.currentState!.validate()) {
      if (typeInciNew != null) {
        if (_bytes != null) {
          _dialogLoading();
          final incidence = await _dataRepository.updaIncid(map: {
            'title': _titleCtrl.text,
            'description': _descCtrl.text,
            'idTypeIncid': typeInciNew!.id.toString(),
            'idIncid': idIncid.toString(),
            'pdf': base64Encode(_bytes!),
          }); Get.back();
          if (incidence != null) {
            _bytes = null;
            _titleCtrl.clear();
            _descCtrl.clear();
            _getIncids(typeInci!.id, true);
            Get.back();
          } else {
            _snackBar(Colors.red, 'ERROR', 'Error al crear la incidencia');
          }
        } else {
          _snackBar(Colors.red, 'ERROR', 'Seleccione un archivo PDF');
        }
      } else {
        _snackBar(Colors.red, 'ERROR', 'Seleccione un tipo de incidente');
      }
    }
  }
}
