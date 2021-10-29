import 'package:get/get.dart';

import 'incides_details_logic.dart';

class IncidesDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncidesDetailsLogic>(
        () => IncidesDetailsLogic(Get.parameters['idIncide'] ?? ''));
  }
}
