import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/core/utils/helpers/http/http.dart';
import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/login_model.dart';
import 'package:incidencias/app/data/models/response_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';

class DbProvider {
  final Http _http;

  DbProvider(this._http);

  Future<LoginModel?> login(
      {required String user, required String password}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.post,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'login', 'user': user, 'password': password});
      return LoginModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<TypeInciModel?> typeInci() async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'typeInci'});
      return TypeInciModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> createIncidence(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.post,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'incidence', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<IncidencesModel?> getIncidences(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'incidences', ...map});
      return IncidencesModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }
}
