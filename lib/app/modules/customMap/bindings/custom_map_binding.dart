import 'package:get/get.dart';

import '../controllers/custom_map_controller.dart';

class CustomMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomMapController>(
      () => CustomMapController(),
    );
  }
}
