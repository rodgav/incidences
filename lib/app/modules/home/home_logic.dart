import 'package:get/get.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';

class HomeLogic extends GetxController {
  final lastName = AuthService.to.lastName ?? '';
  final name = AuthService.to.name ?? '';
  final role = AuthService.to.role ?? '';
  String _selectDrawer = 'Incidentes';

  String get selectDrawer => _selectDrawer;

  void closeSess() async {
    await AuthService.to.logout();
    Get.rootDelegate.toNamed(Routes.home);
  }

  void selDrawer(String value) {
    _selectDrawer = value;
    update(['drawer']);
    switch (value) {
      case 'Incidentes':
        Get.rootDelegate.toNamed(Routes.incides);
        break;
      case 'Soluciones':
        Get.rootDelegate.toNamed(Routes.solutions);
        break;
      case 'Usuarios':
        Get.rootDelegate.toNamed(Routes.users);
        break;
    }
  }
}
