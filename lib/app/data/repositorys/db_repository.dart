import 'package:incidencias/app/data/models/incidences_model.dart';
import 'package:incidencias/app/data/models/login_model.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/models/response_model.dart';
import 'package:incidencias/app/data/models/type_inci_model.dart';
import 'package:incidencias/app/data/providers/db_provider.dart';

class DbRepository {
  final _dbProvider = Get.find<DbProvider>();

  Future<LoginModel?> login({required String user, required String password}) =>
      _dbProvider.login(user: user, password: password);

  Future<TypeInciModel?> typeInci() => _dbProvider.typeInci();

  Future<ResponseModel?> createIncidence({required Map<String, String> map}) =>
      _dbProvider.createIncidence(map: map);

  Future<IncidencesModel?> getIncidences({required Map<String, String> map}) =>
      _dbProvider.getIncidences(map: map);
}
