import 'package:get/get.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/core/utils/helpers/http/http.dart';
import 'package:incidencias/app/data/providers/db_provider.dart';
import 'package:incidencias/app/data/repositorys/db_repository.dart';

class DependencyInjection {
  static void init() {
    final _http = Http();
    Get.put<EncryptHelper>(EncryptHelper());
    Get.put<DbProvider>(DbProvider(_http));
    Get.put<DbRepository>(DbRepository());
  }
}
