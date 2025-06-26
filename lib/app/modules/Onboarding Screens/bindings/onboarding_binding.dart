import 'package:get/get.dart';
import 'package:test1/app/modules/Onboarding%20Screens/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}