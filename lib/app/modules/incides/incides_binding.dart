import 'package:get/get.dart';

import 'incides_logic.dart';

class IncidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IncidesLogic());
  }
}
