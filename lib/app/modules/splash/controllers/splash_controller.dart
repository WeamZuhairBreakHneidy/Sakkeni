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
    await Future.delayed(Duration(seconds: 2)); // optional delay

    final box = GetStorage();
    final rememberMe = box.read('rememberMe') ?? false;
    final hasUser= box.read('hasUser') ?? false;
    if (rememberMe && hasUser) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
