import 'package:get/get.dart';

class BaseTabController extends GetxController {
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateTabFromRoute();
  }

  @override
  void onClose() {
    selectedTab.value = 0;
    super.onClose();
  }

  void updateTabFromRoute() {
    final type = Get.parameters['type'];

    switch (type) {
      case 'rent':
        selectedTab.value = 0;
        break;
      case 'purchase':
        selectedTab.value = 1;
        break;
      case 'offplan':
        selectedTab.value = 2;
        break;
      default:
        selectedTab.value = 0;
    }
  }

  String get currentType {
    switch (selectedTab.value) {
      case 0:
        return 'rent';
      case 1:
        return 'purchase';
      case 2:
        return 'offplan';
      default:
        return 'rent';
    }
  }
}
