import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage1({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية
        Positioned.fill(child: Container(color: AppColors.white)),
        Positioned.fill(child: Container(color: AppColors.gray1)),

        // المحتوى
        Column(
          children: [
            SizedBox(height: 103.h),
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
            const Spacer(),

            // Stack الصورة والنقاط معاً
            Stack(
              children: [
                Image.asset(
                  'assets/backgrounds/onboarding1.png',
                  width: double.infinity,
                  // height: 280.h,
                  fit: BoxFit.fitHeight,
                ),
                Positioned(
                  bottom: 24.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 10.h,
                        dotWidth: 10.w,
                        activeDotColor: AppColors.background1,
                        dotColor: AppColors.SmoothPageIndicator.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
