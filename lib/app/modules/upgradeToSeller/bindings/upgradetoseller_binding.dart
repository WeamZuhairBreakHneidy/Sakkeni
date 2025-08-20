import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/auth_controller.dart';

import '../../auth/controllers/profile_controller.dart';
import '../controllers/upgradetoseller_controller.dart';

class UpgradeToSellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeToSellerController>(
      () => UpgradeToSellerController(),
    );
    Get.lazyPut<AuthController>(() => AuthController());

  }
}
