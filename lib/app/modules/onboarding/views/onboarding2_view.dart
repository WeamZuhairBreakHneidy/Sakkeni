import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';

class OnboardingPage2 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/onboarding2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(child: Container(color: AppColors.gray2)),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/Logo.png',
                                  height: 90.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 40.h),
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
                                SizedBox(height: 20.h),
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.h, top: 32.h),
                            child: Row(
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
                                    activeDotColor: AppColors.background,
                                    dotColor: AppColors.SmoothPageIndicator.withOpacity(0.4),
                                  ),
                                ),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
