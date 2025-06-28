import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController {
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _syncTabWithQueryParam();
  }

  void updateTabFromRoute() {
    _syncTabWithQueryParam();
  }

  void _syncTabWithQueryParam() {
    final type = Get.parameters['type'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });
  }

}
