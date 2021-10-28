import 'package:get/get.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';

class HomeLogic extends GetxController {
  final lastName = AuthService.to.lastName ?? '';
  final _role = AuthService.to.role ?? '';

  void toDashBoard() {
    if(_role=='admin') {
      Get.rootDelegate.toNamed(Routes.dashboard);
    }
  }
}
