// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    required this.error,
    required this.mensaje,
  });

  bool error;
  String mensaje;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    error: json["error"],
    mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "mensaje": mensaje,
  };
}
