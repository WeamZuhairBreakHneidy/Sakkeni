import 'package:get/get.dart';

import '../controllers/service_provider_details_controller.dart';

class ServiceProviderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderDetailsController>(
          () => ServiceProviderDetailsController(),
    );
  }
}
