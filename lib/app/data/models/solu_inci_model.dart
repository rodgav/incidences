// To parse this JSON data, do
//
//     final soluInciModel = soluInciModelFromJson(jsonString);

import 'dart:convert';

import 'package:incidencias/app/data/models/incidences_model.dart';

SoluInciModel soluInciModelFromJson(String str) =>
    SoluInciModel.fromJson(json.decode(str));

String soluInciModelToJson(SoluInciModel data) => json.encode(data.toJson());

class SoluInciModel {
  SoluInciModel({
    required this.error,
    required this.mensaje,
    required this.total,
    required this.soluInci,
  });

  bool error;
  String mensaje;
  int total;
  List<SoluInci> soluInci;

  factory SoluInciModel.fromJson(Map<String, dynamic> json) => SoluInciModel(
        error: json["error"],
        mensaje: json["mensaje"],
        total: json["total"] ?? 0,
        soluInci: json["soluInci"] != null
            ? List<SoluInci>.from(
                json["soluInci"].map((x) => SoluInci.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "soluInci": List<dynamic>.from(soluInci.map((x) => x.toJson())),
      };
}

class SoluInci {
  SoluInci({
    required this.idIncid,
    required this.idSolution,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.title,
    required this.description,
    required this.pdfUrl,
    required this.dateCreate,
    required this.dateModifi,
    required this.incidence,
  });

  int idIncid;
  int idSolution;
  String name;
  String lastName;
  String phone;
  String title;
  String description;
  String pdfUrl;
  DateTime dateCreate;
  DateTime dateModifi;
  List<Incidence> incidence;

  factory SoluInci.fromJson(Map<String, dynamic> json) => SoluInci(
      idIncid: json["idIncid"],
      idSolution: json["idSolution"],
      name: json["name"].toString(),
      lastName: json["lastName"].toString(),
      phone: json["phone"].toString(),
      title: json["title"].toString(),
      description: json["description"].toString(),
      pdfUrl: json["pdfUrl"].toString(),
      dateCreate: DateTime.parse(json["dateCreate"]),
      dateModifi: DateTime.parse(json["dateModifi"]),
      incidence: json["0"] != null
          ? List<Incidence>.from(
              json["0"].map((x) => Incidence.fromJson(x)))
          : []);

  Map<String, dynamic> toJson() => {
        "idIncid": idIncid,
        "idSolution": idSolution,
        "name": name,
        "lastName": lastName,
        "phone": phone,
        "title": title,
        "description": description,
        "pdfUrl": pdfUrl,
        "dateCreate": dateCreate.toIso8601String(),
        "dateModifi": dateModifi.toIso8601String(),
        "incidence": incidence,
      };
}
