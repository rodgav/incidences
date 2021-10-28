import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/data/models/login_model.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final _encryptHelper = Get.find<EncryptHelper>();
  final _getStorage = GetStorage();

  bool get isLoggedIn => _getStorage.read('login') ?? false;

  String? get userId =>
      _encryptHelper.decrypt(_getStorage.read('userId') ?? '');

  String? get role => _encryptHelper.decrypt(_getStorage.read('role') ?? '');

  String? get name => _encryptHelper.decrypt(_getStorage.read('name') ?? '');

  String? get lastName =>
      _encryptHelper.decrypt(_getStorage.read('lastName') ?? '');

  String? get user => _encryptHelper.decrypt(_getStorage.read('user') ?? '');

  Future<void> login(Login login) async {
    try {
      await _getStorage.write('userId', _encryptHelper.encrypt(login.id.toString()));
      await _getStorage.write('role', _encryptHelper.encrypt(login.role));
      await _getStorage.write('name', _encryptHelper.encrypt(login.name));
      await _getStorage.write('lastName', _encryptHelper.encrypt(login.lastName));
      await _getStorage.write('user', _encryptHelper.encrypt(login.user));
      await _getStorage.write('login', true);
    } catch (e) {
      debugPrint('ocurrio un error $e');
    }
  }

  Future<void> logout() async {
    await _getStorage.erase();
  }
}
