import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';

class LoginLogic extends GetxController {
  final _encrypt = Get.find<EncryptHelper>();
  final _dataRepository = Get.find<DbRepository>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return (!regex.hasMatch(value ?? '')) ? 'Ingrese su correo' : null;
  }

  String? isNotEmpty(String? text) {
    if (text != null) if (text.isNotEmpty) return null;
    return 'Ingrese su contraseña';
  }

  /*@override
  void onReady() {
    emailCtrl.text = 'admin@gmail.com';
    passCtrl.text = 'passwordUserAdmin';
    super.onReady();
  }*/

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      _dialogLoading();
      final userModel = await _dataRepository.login(
          user: emailCtrl.text.trim(),
          password: _encrypt.encrypt(passCtrl.text.trim()));
      Get.back();
      if (userModel != null) {
        if (!userModel.error) {
          await AuthService.to.login(userModel.users[0]);
          Get.rootDelegate.offNamed(Routes.home);
        } else {
          _snackBar(Colors.red, 'Ocurrio un error', userModel.mensaje);
        }
      } else {
        _snackBar(
            Colors.red, 'Ocurrio un error', 'Contactese con el administrador');
      }
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
