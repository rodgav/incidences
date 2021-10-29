// To parse this JSON data, do
//
//     final typeInciModel = typeInciModelFromJson(jsonString);

import 'dart:convert';

TypeInciModel typeInciModelFromJson(String str) =>
    TypeInciModel.fromJson(json.decode(str));

String typeInciModelToJson(TypeInciModel data) => json.encode(data.toJson());

class TypeInciModel {
  TypeInciModel({
    required this.error,
    required this.mensaje,
    required this.typeInci,
  });

  bool error;
  String mensaje;
  List<TypeInci> typeInci;

  factory TypeInciModel.fromJson(Map<String, dynamic> json) => TypeInciModel(
        error: json["error"],
        mensaje: json["mensaje"],
        typeInci: json["typeInci"] != null
            ? List<TypeInci>.from(
                json["typeInci"].map((x) => TypeInci.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "mensaje": mensaje,
        "typeInci": List<dynamic>.from(typeInci.map((x) => x.toJson())),
      };
}

class TypeInci {
  TypeInci({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory TypeInci.fromJson(Map<String, dynamic> json) => TypeInci(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
