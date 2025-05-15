import 'package:get/get.dart';
import 'package:test1/app/modules/splash/controllers/splash_controller.dart';
import '../controllers/root_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RootController());
    Get.put(SplashController());
  }
}
