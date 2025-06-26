import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';

class OnboardingPage2 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية
        Positioned.fill(
          child: Image.asset(
            'assets/backgrounds/onboarding2.png',
            fit: BoxFit.fitHeight,
          ),
        ),

        // طبقة تغطية رمادية شفافة
        Positioned.fill(child: Container(color: AppColors.gray2)),

        // النصوص
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 103.h),
              Center(child: Image.asset('assets/Logo.png', height: 58.h)),
              SizedBox(height: 297.h),
              Text(
                "Everything You Need\nUnder One Roof",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.surface,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.h),
              Text(
                "From construction to careers, bring\nyour vision or find your next role.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.surface,
                  fontSize: 16.sp,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // أزرار Previous + Next + مؤشر النقاط على نفس الخط (نصوص بدلاً من الأسهم)
        Positioned(
          bottom: 24.h,
          left: 24.w,
          right: 24.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر Previous
              GestureDetector(
                onTap: () {
                  controller.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  "Previous",
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

              SizedBox(width: 78.w),

              // مؤشر النقاط
              SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 10.h,
                  dotWidth: 10.w,
                  activeDotColor: AppColors.background1,
                  dotColor: AppColors.SmoothPageIndicator.withOpacity(0.4),
                ),
              ),

              SizedBox(width: 78.w),

              // زر Next
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
    );
  }
}
