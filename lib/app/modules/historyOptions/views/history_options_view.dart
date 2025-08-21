import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../../../core/theme/colors.dart';
class HistoryOptionsView extends StatelessWidget {
  const HistoryOptionsView({super.key});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
            child: Center(
              child: SizedBox(
                width: 110.w,
                height: 90.h,
                child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Animated Title ---
                    SizedBox(
                      height: 50.h,
                      child: Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Your History",
                              textStyle: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background,
                              ),
                              speed: const Duration(milliseconds: 150),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 500),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "View your past activity easily",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    // --- My Services Card (Animated) ---
                    _HistoryOptionCard(
                      title: "My Services",
                      subtitle: "Check the services you provide",
                      icon: Icons.design_services,

                      onTap: () {
                        final isServiceProvider =
                            box.read('isServiceProvider') ?? false;
                        if (isServiceProvider) {
                          Get.toNamed(Routes.MY_SERVICES);
                        } else {
                          showUpgradeToSellerDialog();
                        }
                      },
                    ).animate().fade(duration: 500.ms).slideX(begin: -0.2),

                    SizedBox(height: 25.h),

                    // --- My Properties Card (Animated) ---
                    _HistoryOptionCard(
                          title: "My Properties",
                          subtitle: "Review your listed properties",
                          icon: Icons.home_rounded,

                          onTap: () {
                            final isSeller = box.read('isSeller') ?? false;
                            if (isSeller) {
                              Get.toNamed(Routes.MY_PROPERTIES);
                            } else {
                              showUpgradeToSellerDialog();
                            }
                          },
                        )
                        .animate()
                        .fade(duration: 500.ms, delay: 200.ms)
                        .slideX(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// --- Extracted Widget for the Option Card ---
class _HistoryOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HistoryOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primary, width: 2), // <-- هنا الحد
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(icon, color: AppColors.primary, size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
