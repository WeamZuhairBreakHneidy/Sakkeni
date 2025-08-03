import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/logout_controller.dart';




class LogoutBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LogoutController>(
          () => LogoutController(),
    );
  }
}
