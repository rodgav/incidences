// To parse this JSON data, do
//
//     final incidencesModel = incidencesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

IncidencesModel incidencesModelFromJson(String str) =>
    IncidencesModel.fromJson(json.decode(str));

String incidencesModelToJson(IncidencesModel data) =>
    json.encode(data.toJson());

class IncidencesModel {
  IncidencesModel({
    required this.error,
    required this.mensaje,
    required this.total,
    required this.incidences,
  });

  bool error;
  String mensaje;
  int total;
  List<Incidence> incidences;

  factory IncidencesModel.fromJson(Map<String, dynamic> json) =>
      IncidencesModel(
        error: json["error"],
        mensaje: json["mensaje"],
        total: json["total"],
        incidences: json["incidences"] != null
            ? List<Incidence>.from(
                json["incidences"].map((x) => Incidence.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "total": total,
        "incidences": List<dynamic>.from(incidences.map((x) => x.toJson())),
      };
}

class Incidence {
  Incidence({
    required this.name,
    required this.lastName,
    required this.phone,
    required this.typeIncid,
    required this.title,
    required this.description,
    required this.pdfUrl,
    required this.dateCreate,
    required this.dateModifi,
  });

  String name;
  String lastName;
  String phone;
  String typeIncid;
  String title;
  String description;
  String pdfUrl;
  DateTime dateCreate;
  DateTime dateModifi;

  factory Incidence.fromJson(Map<String, dynamic> json) => Incidence(
        name: json["name"].toString(),
        lastName: json["lastName"].toString(),
        phone: json["phone"].toString(),
        typeIncid: json["typeIncid"].toString(),
        title: json["title"].toString(),
        description: json["description"].toString(),
        pdfUrl: json["pdfURL"].toString(),
        dateCreate: DateTime.parse(json["dateCreate"]),
        dateModifi: DateTime.parse(json["dateModifi"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastName,
        "phone": phone,
        "typeIncid": typeIncid,
        "title": title,
        "description": description,
        "pdfURL": pdfUrl,
        "dateCreate": dateCreate.toIso8601String(),
        "dateModifi": dateModifi.toIso8601String(),
      };
}
