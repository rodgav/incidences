import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';

class HomeLogic extends GetxController {
  final _dataRepository = Get.find<DbRepository>();
  final _encrypt = Get.find<EncryptHelper>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _newPass1Ctrl = TextEditingController();
  final lastName = AuthService.to.lastName ?? '';
  final name = AuthService.to.name ?? '';
  final role = AuthService.to.role ?? '';
  String _selectDrawer = 'Incidentes';

  String get selectDrawer => _selectDrawer;

  @override
  void onClose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _newPass1Ctrl.dispose();
    super.onClose();
  }

  void closeSess() async {
    await AuthService.to.logout();
    Get.rootDelegate.toNamed(Routes.home);
  }

  void selDrawer(String value) {
    _selectDrawer = value;
    update(['drawer']);
    switch (value) {
      case 'Incidentes':
        Get.rootDelegate.toNamed(Routes.incides);
        break;
      case 'Soluciones':
        Get.rootDelegate.toNamed(Routes.solutions);
        break;
      case 'Usuarios':
        Get.rootDelegate.toNamed(Routes.users);
        break;
    }
  }

  void toBack() {
    Get.rootDelegate.popRoute();
  }

  String? isNotEmpty(String? text) {
    if (text != null) if (text.isNotEmpty) return null;
    return 'Ingrese datos';
  }

  void updaPass() {
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
                          'Cambiar contraseña',
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
                              child: const Icon(Icons.close, color: Colors.red),
                              onTap: toBack),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contraseña actual',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    controller: _oldPassCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Contraseña actual',
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
                    'Nueva contraseña',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _newPassCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Nueva contraseña',
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
                    'Repetir nueva contraseña',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _newPass1Ctrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Repetir nueva contraseña',
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
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: _updatePassw,
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

  void _updatePassw() async {
    if (_formKey.currentState!.validate()) {
      if (_newPassCtrl.text == _newPass1Ctrl.text) {
        _dialogLoading();
        final incidence = await _dataRepository.updaPassw(map: {
          'idUser': AuthService.to.userId.toString(),
          'user': AuthService.to.user.toString(),
          'oldPassword': _encrypt.encrypt(_oldPassCtrl.text),
          'newPassword': _encrypt.encrypt(_newPassCtrl.text),
        });
        Get.back();
        if (incidence != null) {
          _oldPassCtrl.clear();
          _newPassCtrl.clear();
          _newPass1Ctrl.clear();
          Get.back();
        } else {
          _snackBar(Colors.red, 'ERROR', 'Contraseña actual incorrecta');
        }
      } else {
        _snackBar(Colors.red, 'ERROR',
            'Nueva contraseña tiene que ser igual a repetir nueva contraseña');
      }
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
}
