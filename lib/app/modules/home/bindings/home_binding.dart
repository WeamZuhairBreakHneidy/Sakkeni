import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/logout_controller.dart';
import '../../auth/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedPropertiesController>(() => RecommendedPropertiesController());
    Get.lazyPut<LogoutController>(() => LogoutController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}