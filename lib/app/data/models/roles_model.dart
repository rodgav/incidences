// To parse this JSON data, do
//
//     final rolesModel = rolesModelFromJson(jsonString);

import 'dart:convert';

RolesModel rolesModelFromJson(String str) =>
    RolesModel.fromJson(json.decode(str));

String rolesModelToJson(RolesModel data) => json.encode(data.toJson());

class RolesModel {
  RolesModel({
    required this.error,
    required this.mensaje,
    required this.roles,
  });

  bool error;
  String mensaje;
  List<Role> roles;

  factory RolesModel.fromJson(Map<String, dynamic> json) => RolesModel(
        error: json["error"],
        mensaje: json["mensaje"],
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  Role({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
