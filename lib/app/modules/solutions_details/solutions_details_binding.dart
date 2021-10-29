import 'package:get/get.dart';

import 'solutions_details_logic.dart';

class SolutionsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SolutionsDetailsLogic>(() => SolutionsDetailsLogic(Get.parameters['idSolut'] ?? ''));
  }
}
