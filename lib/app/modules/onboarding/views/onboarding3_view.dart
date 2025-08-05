import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/responsive_buttun.dart';

class OnboardingPage3 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/onboarding3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(child: Container(color: AppColors.gray3)),

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
                                SizedBox(height: 20.h),
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
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 24.h, top: 32.h),
                            child: Column(
                              children: [
                                ResponsiveButton(
                                  onPressed: () {
                                    final box = GetStorage();
                                    box.write('seenOnboarding', true);
                                    Get.toNamed(Routes.AUTH);
                                  },
                                  clickable: true,
                                  buttonWidth: double.infinity,
                                  buttonHeight: 56.h,
                                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Text(
                                    "Get Started",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.tabtext, // primary text color on light button
                                    ),
                                  ),
                                ),
                                80.verticalSpace,
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         controller.previousPage(
                                //           duration: Duration(milliseconds: 300),
                                //           curve: Curves.easeInOut,
                                //         );
                                //       },
                                //       child: Text(
                                //         "Previous",
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 12.sp,
                                //           fontWeight: FontWeight.w500,
                                //           shadows: [
                                //             Shadow(
                                //               color: Colors.black45,
                                //               blurRadius: 4,
                                //               offset: Offset(1, 1),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //     SmoothPageIndicator(
                                //       controller: controller,
                                //       count: 3,
                                //       effect: WormEffect(
                                //         dotHeight: 10.h,
                                //         dotWidth: 10.w,
                                //         activeDotColor: AppColors.background,
                                //         dotColor: AppColors.SmoothPageIndicator.withOpacity(0.4),
                                //       ),
                                //     ),
                                //     GestureDetector(
                                //       onTap: () {
                                //         Get.toNamed(Routes.AUTH);
                                //       },
                                //       child: Text(
                                //         "Get started",
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 12.sp,
                                //           fontWeight: FontWeight.w500,
                                //           shadows: [
                                //             Shadow(
                                //               color: Colors.black45,
                                //               blurRadius: 4,
                                //               offset: Offset(1, 1),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
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
