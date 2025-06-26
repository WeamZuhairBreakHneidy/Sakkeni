import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class TabControllerX extends GetxController {
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _syncTabWithRoute();
  }

  void _syncTabWithRoute() {
    switch (Get.currentRoute) {
      case Routes.RENT:
        selectedTab.value = 0;
        break;
      case Routes.PURCHASE:
        selectedTab.value = 1;
        break;
      case Routes.OFFPLANE:
        selectedTab.value = 2;
        break;
      default:
        selectedTab.value = 0;
    }
  }

  void updateTabFromRoute() {
    switch (Get.currentRoute) {
      case Routes.RENT:
        selectedTab.value = 0;
        break;
      case Routes.PURCHASE:
        selectedTab.value = 1;
        break;
      case Routes.OFFPLANE:
        selectedTab.value = 2;
        break;
      default:
        selectedTab.value = 0;
    }
  }
}
