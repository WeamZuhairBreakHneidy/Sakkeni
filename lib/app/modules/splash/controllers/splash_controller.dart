import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(Duration(seconds: 2)); // Optional splash delay

    final box = GetStorage();
    final seenOnboarding = box.read('seenOnboarding') ?? false;
    final rememberMe = box.read('rememberMe') ?? false;
    final hasUser = box.hasData('user'); // safer than manual flag

    if (!seenOnboarding) {
      // First time user → show onboarding
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (rememberMe && hasUser) {
      // Already logged in → go to home
      Get.offAllNamed(Routes.HOME);
    } else {
      // Seen onboarding but not logged in
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
