import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/data/models/roles_model.dart';
import 'package:incidencias/app/data/models/users_model.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';
import 'package:incidencias/app/data/services/auth_service.dart';

class UsersLogic extends GetxController {
  final _dataRepository = Get.find<DbRepository>();
  final _encrypt = Get.find<EncryptHelper>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _userCtrl = TextEditingController();
  final scrollController = ScrollController();
  UsersModel? _usersModel;
  RolesModel? _rolesModel;
  Role? _role;
  Role? _roleNew;
  int _index = 0;
  final int _limit = 25;

  UsersModel? get usersModel => _usersModel;

  RolesModel? get rolesModel => _rolesModel;

  Role? get role => _role;

  Role? get roleNew => _roleNew;

  @override
  void onReady() {
    _getTypeInci();
    _setupScrollController();
    super.onReady();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _userCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _getTypeInci() async {
    _rolesModel = await _dataRepository.roles();
    if (rolesModel != null) {
      _rolesModel!.roles.insert(0, Role(id: 0, name: 'Todos'));
      _role = rolesModel!.roles[0];
      update(['roles']);
      _getUsers(role!.id, false);
    }
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        _getUsers(role!.id, false);
      }
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        _getUsers(role!.id, true);
      }
    });
  }

  void selectRoles(Role data) {
    _role = data;
    update(['roles']);
    _getUsers(data.id, true);
  }

  void selectRolesNew(Role data) {
    _roleNew = data;
    update(['rolesNew']);
  }

  void selPopup(String value, User user) {
    switch (value) {
      case 'edit':
        if (AuthService.to.role == 'admin') {
          newUser('edit', idUser: user.id);
        } else {
          _snackBar(Colors.red, 'ERROR',
              'No tienes permisos para realizar esta acción');
        }
        break;
      default:
        break;
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

  void _getUsers(int idRole, bool reload) async {
    if (reload) {
      _usersModel = UsersModel(error: false, mensaje: '', total: 0, users: []);
      _index = 0;
    }
    UsersModel oldUsersModel;
    UsersModel newUsersModel;
    if (usersModel != null) {
      oldUsersModel = usersModel!;
    } else {
      oldUsersModel =
          UsersModel(error: false, mensaje: '', total: 0, users: []);
    }
    if (oldUsersModel.total >= _index) {
      final newUser = await _dataRepository.getUsers(map: {
        'idRole': idRole == 0 ? '' : idRole.toString(),
        'index': _index.toString(),
        'limit': _limit.toString()
      });
      if (newUser != null) {
        newUsersModel = newUser;
      } else {
        newUsersModel =
            UsersModel(error: false, mensaje: '', total: 0, users: []);
      }
      _index = _index + _limit + 1;
    } else {
      newUsersModel =
          UsersModel(error: false, mensaje: '', total: 0, users: []);
    }
    _usersModel = oldUsersModel;
    _usersModel!.total = newUsersModel.total;
    _usersModel!.users.addAll(newUsersModel.users);
    update(['users']);
  }

  String? isNotEmpty(String? text) {
    if (text != null) if (text.isNotEmpty) return null;
    return 'Ingrese datos';
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return (!regex.hasMatch(value ?? '')) ? 'Ingrese su correo' : null;
  }

  void toBack() {
    Get.rootDelegate.popRoute();
  }

  void newUser(String action, {int idUser = 0}) {
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
                          '${action == 'new' ? 'Nuevo' : 'Actualizar'} Usuario',
                          style: const TextStyle(
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
                    'Nombres',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    controller: _nameCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Nombres',
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
                    'Apellidos',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _lastNameCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Apellidos',
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
                    'Teléfono',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _phoneCtrl,
                    validator: (value) => isNotEmpty(value),
                    decoration: InputDecoration(
                        hintText: 'Teléfono',
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
                    'Email',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  TextFormField(
                    maxLines: 2,
                    controller: _userCtrl,
                    validator: (value) => validateEmail(value),
                    decoration: InputDecoration(
                        hintText: 'Email',
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
                  GetBuilder<UsersLogic>(
                      id: 'typeIncisNew',
                      builder: (_) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<Role>(
                            isExpanded: true,
                            value: roleNew,
                            hint: const Text('Tipo de incidente'),
                            underline: const SizedBox(),
                            items: rolesModel!.roles
                                .map((e) => DropdownMenuItem<Role>(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (value) => selectRolesNew(value as Role),
                          ),
                        );
                      }),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () => action == 'new'
                            ? _createUser()
                            : _updateUser(idUser),
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

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      if (roleNew != null) {
        if (AuthService.to.userId != null) {
          _dialogLoading();
          final response = await _dataRepository.createUser(map: {
            'idRole': roleNew!.id.toString(),
            'name': _nameCtrl.text,
            'lastName': _lastNameCtrl.text,
            'phone': _phoneCtrl.text,
            'user': _userCtrl.text,
            'password': _encrypt.encrypt(_phoneCtrl.text),
          });
          if (response != null) {
            _nameCtrl.clear();
            _lastNameCtrl.clear();
            _phoneCtrl.clear();
            _userCtrl.clear();
            _getUsers(role!.id, true);
            toBack();
          } else {
            _snackBar(Colors.red, 'ERROR', 'Error al crear usuario');
          }
        } else {
          _snackBar(Colors.red, 'ERROR',
              'No tienes permisos para realizar esta acción');
        }
      } else {
        _snackBar(Colors.red, 'ERROR', 'Seleccione un tipo de usuario');
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

  void _updateUser(int idUser) async {
    if (_formKey.currentState!.validate()) {
      if (roleNew != null) {
        _dialogLoading();
        final incidence = await _dataRepository.updaUser(map: {
          'idUser': idUser.toString(),
          'idRole': roleNew!.id.toString(),
          'name': _nameCtrl.text,
          'lastName': _lastNameCtrl.text,
          'phone': _phoneCtrl.text,
          'user': _userCtrl.text,
          'password': _encrypt.encrypt(_phoneCtrl.text),
        });
        toBack();
        if (incidence != null) {
          _nameCtrl.clear();
          _lastNameCtrl.clear();
          _phoneCtrl.clear();
          _userCtrl.clear();
          _getUsers(role!.id, true);
          toBack();
        } else {
          _snackBar(Colors.red, 'ERROR', 'Error al actualizar usuario');
        }
      } else {
        _snackBar(Colors.red, 'ERROR', 'Seleccione un tipo de usuario');
      }
    }
  }
}
