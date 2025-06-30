import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;
  void onPageChanged(int index) {
    currentPage.value = index;
  }
}