import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';
import 'onboarding1_view.dart';
import 'onboarding2_view.dart';
import 'onboarding3_view.dart';


class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF5F6769),
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: [
            OnboardingPage1(controller: controller.pageController),
            OnboardingPage2(controller: controller.pageController),
            OnboardingPage3(controller: controller.pageController),
          ],
        ),
      ),
    );
  }
}
