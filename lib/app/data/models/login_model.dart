// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.error,
    required this.mensaje,
    required this.login,
  });

  bool error;
  String mensaje;
  List<Login> login;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        error: json["error"],
        mensaje: json["mensaje"],
        login: json["login"] != null
            ? List<Login>.from(json["login"].map((x) => Login.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "login": List<dynamic>.from(login.map((x) => x.toJson())),
      };
}

class Login {
  Login({
    required this.id,
    required this.role,
    required this.name,
    required this.lastName,
    required this.user,
  });

  int id;
  String role;
  String name;
  String lastName;
  String user;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        lastName: json["lastName"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "lastName": lastName,
        "user": user,
      };
}
