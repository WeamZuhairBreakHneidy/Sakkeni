import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddpropertyTabsController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void goToNextStep() {
    if (currentPage.value < 2) {
      currentPage.value++;

    }
  }

  void goToPreviousStep() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
}