import 'package:get/get.dart';

import '../controllers/my_services_controller.dart';

class MyServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyServicesController>(
      () => MyServicesController(),
    );
  }
}
