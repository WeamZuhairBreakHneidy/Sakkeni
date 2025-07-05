import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.white)),
          Positioned.fill(child: Container(color: AppColors.gray1)),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 76.w),
                    child: Image.asset('assets/Logo.png', height: 58.h),
                  ),
                  SizedBox(height: 83.5.h),
                  Text(
                    "One Platform,\nInfinite Property Possibilities",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  Text(
                    "Buy sell or rent, your next move\nstarts here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.surface, fontSize: 16.sp),
                  ),

                  Stack(
                    children: [
                      Image.asset(
                        'assets/backgrounds/onboarding1.png',
                        width: 1.sw,
                        fit: BoxFit.cover,
                        height: 440.h,
                      ),
                      Positioned(
                        bottom: 24.h,
                        left: 180.w,
                        right: 24.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              effect: WormEffect(
                                dotHeight: 10.h,
                                dotWidth: 10.w,
                                activeDotColor: AppColors.background1,
                                dotColor: AppColors
                                    .SmoothPageIndicator.withOpacity(0.4),
                              ),
                            ),

                            // Next
                            GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
