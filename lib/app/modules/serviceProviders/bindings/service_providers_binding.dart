import 'package:get/get.dart';

import '../../auth/controllers/logout_controller.dart';
import '../controllers/service_providers_controller.dart';

class ServiceProvidersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProvidersController>(() => ServiceProvidersController());
    Get.lazyPut<LogoutController>(() => LogoutController());
  }
}
