import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/roles_model.dart';
import 'package:incidencias/app/data/models/users_model.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/models/response_model.dart';
import 'package:incidencias/app/data/models/solu_inci_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';
import 'package:incidencias/app/data/providers/db_provider.dart';

class DbRepository {
  final _dbProvider = Get.find<DbProvider>();

  Future<UsersModel?> login({required String user, required String password}) =>
      _dbProvider.login(user: user, password: password);

  Future<TypeInciModel?> typeInci() => _dbProvider.typeInci();

  Future<ResponseModel?> createIncidence({required Map<String, String> map}) =>
      _dbProvider.createIncidence(map: map);

  Future<IncidencesModel?> getIncidences({required Map<String, String> map}) =>
      _dbProvider.getIncidences(map: map);

  Future<IncidencesModel?> getIncidId({required Map<String, String> map}) =>
      _dbProvider.getIncidId(map: map);

  Future<ResponseModel?> createSolution({required Map<String, String> map}) =>
      _dbProvider.createSolution(map: map);

  Future<SoluInciModel?> getSoluIncidIdIncid(
          {required Map<String, String> map}) =>
      _dbProvider.getSoluIncidIdIncid(map: map);

  Future<SoluInciModel?> getSolutions({required Map<String, String> map}) =>
      _dbProvider.getSolutions(map: map);

  Future<SoluInciModel?> getSolution({required Map<String, String> map}) =>
      _dbProvider.getSolution(map: map);

  Future<UsersModel?> getUsers({required Map<String, String> map}) =>
      _dbProvider.getUsers(map: map);

  Future<RolesModel?> roles() => _dbProvider.roles();

  Future<ResponseModel?> updaPassw({required Map<String, String> map}) =>
      _dbProvider.updaPassw(map: map);

  Future<ResponseModel?> updaRole({required Map<String, String> map}) =>
      _dbProvider.updaRole(map: map);

  Future<ResponseModel?> updaIncid({required Map<String, String> map}) =>
      _dbProvider.updaIncid(map: map);

  Future<ResponseModel?> updaSolutInci({required Map<String, String> map}) =>
      _dbProvider.updaSolutInci(map: map);

  Future<ResponseModel?> createUser({required Map<String, String> map}) =>
      _dbProvider.createUser(map: map);

  Future<ResponseModel?> updaUser({required Map<String, String> map}) =>
      _dbProvider.updaUser(map: map);
}
