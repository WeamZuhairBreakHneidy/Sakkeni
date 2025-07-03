import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';

class OnboardingPage3 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              // الخلفية
              Positioned.fill(
                child: Image.asset(
                  'assets/backgrounds/onboarding3.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // طبقة شفافة
              Positioned.fill(
                child: Container(color: AppColors.gray3),
              ),

              // المحتوى الرئيسي
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 122.h),
                    Center(
                      child: Image.asset(
                        'assets/Logo.png',
                        height: 58.h,
                      ),
                    ),

                    SizedBox(height: 165.5.h),

                    Text(
                      "From Start To Keys\nin Your Hand!",
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
                      "Because finding a home\nshould be this easy.",
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

                    SizedBox(height: 275.h), // مساحة قبل الأزرار

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.AUTH);
                          },
                          child: Text(
                            "Get started",
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

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
