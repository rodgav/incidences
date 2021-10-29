import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/solu_inci_model.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SolutionsDetailsLogic extends GetxController {
  final String _idSolut;

  SolutionsDetailsLogic(this._idSolut);

  final _dataRepository = Get.find<DbRepository>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  Incidence? _incidence;
  SoluInci? _solution;
  Uint8List? _bytes;
  String _nameFile = 'Seleccionar...';

  Incidence? get incidence => _incidence;

  SoluInci? get solution => _solution;

  @override
  void onReady() {
    _getSolut();
    super.onReady();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _getSolut() async {
    final sulitionModel =
        await _dataRepository.getSolution(map: {'idSolut': _idSolut});
    if (sulitionModel != null) {
      _solution = sulitionModel.soluInci[0];
      update(['solution']);
      _getInciId(_solution!.idIncid);
    }
  }

  void _getInciId(int idIncid) async {
    final incidenceModel =
        await _dataRepository.getIncidId(map: {'idIncid': idIncid.toString()});
    if (incidenceModel != null) {
      _incidence = incidenceModel.incidences[0];
      update(['incidence']);
    }
  }

  void launchPDF(String pdfURL) async {
    await canLaunch(pdfURL)
        ? await launch(pdfURL)
        : throw 'Could not launch $pdfURL';
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

  void updaSolution() {
    if (solution != null) {
      final name = solution!.name;
      final lastName = solution!.lastName;
      if (name == AuthService.to.name && lastName == AuthService.to.lastName ||
          AuthService.to.role == 'admin') {
        _titleCtrl.text = solution!.title;
        _descCtrl.text = solution!.description;
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
                                  child: const Icon(Icons.close,
                                      color: Colors.red),
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
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.red))),
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
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.red))),
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
                      GetBuilder<SolutionsDetailsLogic>(
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
                                        border:
                                            Border.all(color: Colors.black)),
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
                            onPressed: updateSolution,
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
        _snackBar(Colors.red, 'ERROR',
            'No tienes permisos para realizar esta acción');
      }
    } else {
      _snackBar(Colors.red, 'ERROR', 'No existe solución');
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
  void updateSolution() async {
    if (_formKey.currentState!.validate()) {
      if (AuthService.to.userId != null) {
        if (_bytes != null) { _dialogLoading();
          final response = await _dataRepository.updaSolutInci(map: {
            'idSolutInci': _idSolut,
            'title': _titleCtrl.text,
            'description': _descCtrl.text,
            'pdf': base64Encode(_bytes!),
          });toBack();
          if (response != null) {
            _bytes = null;
            _titleCtrl.clear();
            _descCtrl.clear();
            _getSolut();
            toBack();
          } else {
            _snackBar(Colors.red, 'ERROR', 'Error al actualizar la solucíón');
          }
        } else {
          _snackBar(Colors.red, 'ERROR', 'Seleccione un archivo PDF');
        }
      } else {
        _snackBar(Colors.red, 'ERROR',
            'No tienes permisos para realizar esta acción');
      }
    }
  }
}
