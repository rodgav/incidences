import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/models/solu_inci_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class SolutionsLogic extends GetxController {
  final _dataRepository = Get.find<DbRepository>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final scrollController = ScrollController();
  TypeInciModel? _typeInciModel;
  TypeInci? _typeInci;
  SoluInciModel? _soluInciModel;
  Uint8List? _bytes;
  String _nameFile = 'Seleccionar...';
  int _index = 0;
  final int _limit = 25;

  TypeInciModel? get typeInciModel => _typeInciModel;

  TypeInci? get typeInci => _typeInci;

  SoluInciModel? get soluInciModel => _soluInciModel;

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
      _getSolutions(typeInci!.id, false);
    }
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        _getSolutions(typeInci!.id, false);
      }
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        _getSolutions(typeInci!.id, true);
      }
    });
  }

  void selectTypeInci(TypeInci data) {
    _typeInci = data;
    update(['typeIncis']);
    _getSolutions(data.id, true);
  }

  void toPDF(String pdfUrl) async {
    await canLaunch(pdfUrl)
        ? await launch(pdfUrl)
        : throw 'Could not launch $pdfUrl';
  }

  void selPopup(String value, SoluInci soluInci) {
    switch (value) {
      case 'detail':
        Get.rootDelegate
            .toNamed(Routes.solutionsDetails(soluInci.idSolution.toString()));
        break;
      case 'pdf':
        toPDF(soluInci.pdfUrl);
        break;
      case 'edit':
        _updaSolution(soluInci);
        break;
      default:
        break;
    }
  }

  void _getSolutions(int idTypeInci, bool reload) async {
    if (reload) {
      _soluInciModel =
          SoluInciModel(error: false, mensaje: '', total: 0, soluInci: []);

      _index = 0;
    }
    SoluInciModel oldSoluInciModel;
    SoluInciModel newSoluInciModel;
    if (soluInciModel != null) {
      oldSoluInciModel = soluInciModel!;
    } else {
      oldSoluInciModel =
          SoluInciModel(error: false, mensaje: '', total: 0, soluInci: []);
    }
    if (oldSoluInciModel.total >= _index) {
      final newSolu = await _dataRepository.getSolutions(map: {
        'idTypeIncid': idTypeInci == 0 ? '' : idTypeInci.toString(),
        'index': _index.toString(),
        'limit': _limit.toString()
      });
      if (newSolu != null) {
        newSoluInciModel = newSolu;
      } else {
        newSoluInciModel =
            SoluInciModel(error: false, mensaje: '', total: 0, soluInci: []);
      }
      _index = _index + _limit + 1;
    } else {
      newSoluInciModel =
          SoluInciModel(error: false, mensaje: '', total: 0, soluInci: []);
    }
    _soluInciModel = oldSoluInciModel;
    _soluInciModel!.total = newSoluInciModel.total;
    _soluInciModel!.soluInci.addAll(newSoluInciModel.soluInci);
    update(['solutions']);
  }

  void _updaSolution(SoluInci soluInci) {
    final name = soluInci.name;
    final lastName = soluInci.lastName;
    if (name == AuthService.to.name && lastName == AuthService.to.lastName ||
        AuthService.to.role == 'admin') {
      _titleCtrl.text = soluInci.title;
      _descCtrl.text = soluInci.description;
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
                        const Center(
                          child: Text(
                            'Actualizar Solución',
                            style: TextStyle(
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
                                child:
                                    const Icon(Icons.close, color: Colors.red),
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
                              borderSide:
                                  const BorderSide(color: Colors.black)),
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
                              borderSide:
                                  const BorderSide(color: Colors.black)),
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
                      'Seleccione su PDF',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    GetBuilder<SolutionsLogic>(
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
                          onPressed: () => _updateSolution(soluInci.idSolution),
                          child: const Text('Actualizar')),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    } else {
      _snackBar(
          Colors.red, 'ERROR', 'No tienes permisos para realizar esta acción');
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
  void _updateSolution(int idSolut) async {
    if (_formKey.currentState!.validate()) {
        if (_bytes != null) { _dialogLoading();
          final response = await _dataRepository.updaSolutInci(map: {
            'idSolutInci': idSolut.toString(),
            'title': _titleCtrl.text,
            'description': _descCtrl.text,
            'pdf': base64Encode(_bytes!),
          }); Get.back();
          if (response != null) {
            _bytes = null;
            _titleCtrl.clear();
            _descCtrl.clear();
            _getSolutions(typeInci!.id, true);
            Get.back();
          } else {
            _snackBar(Colors.red, 'ERROR', 'Error al actualizar la solucíón');
          }
        } else {
          _snackBar(Colors.red, 'ERROR', 'Seleccione un archivo PDF');
        }
    }
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

  String? isNotEmpty(String? text) {
    if (text != null) if (text.isNotEmpty) return null;
    return 'Ingrese datos';
  }

  void toBack() {
    Get.rootDelegate.popRoute();
  }
}
