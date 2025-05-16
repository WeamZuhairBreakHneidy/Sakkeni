import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void onItemTap(int index) {
    selectedIndex.value = index;

    final List<String> routes = [
      Routes.REGISTER,
      Routes.REGISTER,
      Routes.REGISTER,
      Routes.AUTH
    ];

    if (index < routes.length) {
      Get.toNamed(routes[index]);
    }
  }
}