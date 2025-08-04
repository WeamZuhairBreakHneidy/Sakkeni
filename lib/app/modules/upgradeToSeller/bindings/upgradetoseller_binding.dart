import 'package:get/get.dart';

import '../../auth/controllers/profile_controller.dart';
import '../controllers/upgradetoseller_controller.dart';

class UpgradeToSellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeToSellerController>(
      () => UpgradeToSellerController(),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());

  }
}
