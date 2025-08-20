import 'package:get/get.dart';

import '../controllers/upgrade_to_service_provider_controller.dart';

class UpgradeToServiceProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeToServiceProviderController>(
      () => UpgradeToServiceProviderController(),
    );
  }
}
