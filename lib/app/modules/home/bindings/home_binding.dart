import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/logout_controller.dart';
import 'package:test1/app/modules/auth/controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedPropertiesController>(() => RecommendedPropertiesController());
    Get.lazyPut<LogoutController>(() => LogoutController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}