import 'package:get/get.dart';

import 'solutions_logic.dart';

class SolutionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SolutionsLogic());
  }
}
