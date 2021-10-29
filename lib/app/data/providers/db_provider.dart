import 'package:incidencias/app/core/utils/helpers/http/http.dart';
import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/roles_model.dart';
import 'package:incidencias/app/data/models/users_model.dart';
import 'package:incidencias/app/data/models/response_model.dart';
import 'package:incidencias/app/data/models/solu_inci_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';

class DbProvider {
  final Http _http;

  DbProvider(this._http);

  Future<UsersModel?> login(
      {required String user, required String password}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.post,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'login', 'user': user, 'password': password});
      return UsersModel.fromJson(result.data);
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

  Future<IncidencesModel?> getIncidId(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'incidence', ...map});
      return IncidencesModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> createSolution(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.post,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'solution', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<SoluInciModel?> getSoluIncidIdIncid(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'soluInciIdInci', ...map});
      return SoluInciModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<SoluInciModel?> getSolutions(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'soluInci', ...map});
      return SoluInciModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<SoluInciModel?> getSolution({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'solution', ...map});
      return SoluInciModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<UsersModel?> getUsers({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'users', ...map});
      return UsersModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<RolesModel?> roles() async {
    try {
      final result = await _http.request('',
          method: HttpMethod.get,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          queryParameters: {'accion': 'roles'});
      return RolesModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> updaPassw({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.put,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'updaPassw', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> updaRole({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.put,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'updaRole', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> updaIncid({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.put,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'updaIncid', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> updaSolutInci(
      {required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.put,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'updaSolutInci', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> createUser({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.post,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'createUser', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> updaUser({required Map<String, String> map}) async {
    try {
      final result = await _http.request('',
          method: HttpMethod.put,
          headers: {'token': '112dasd35gfsdq324dfxmhg643FGSD34213fdsf234DS'},
          body: {'accion': 'updaUser', ...map});
      return ResponseModel.fromJson(result.data);
    } catch (_) {
      return null;
    }
  }
}
