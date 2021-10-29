// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  UsersModel({
    required this.error,
    required this.mensaje,
    required this.total,
    required this.users,
  });

  bool error;
  String mensaje;
  int total;
  List<User> users;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        error: json["error"],
        mensaje: json["mensaje"],
        total: json["total"] ?? 0,
        users: json["users"] != null
            ? List<User>.from(json["users"].map((x) => User.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
    required this.id,
    required this.role,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.user,
    required this.active,
  });

  int id;
  String role;
  String name;
  String lastName;
  String phone;
  String user;
  int active;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        role: json["role"].toString(),
        name: json["name"].toString(),
        lastName: json["lastName"].toString(),
        phone: json["phone"].toString(),
        user: json["user"].toString(),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "lastName": lastName,
        "phone": phone,
        "user": user,
        "active": active,
      };
}
