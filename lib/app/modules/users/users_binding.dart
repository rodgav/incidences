import 'package:get/get.dart';

import 'users_logic.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersLogic());
  }
}
