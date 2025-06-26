import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../core/util/device_utils.dart';
import '../../Onboarding Screens/controllers/onboarding_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return  Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                DeviceUtils.isPhone()
                    ? 'assets/backgrounds/phone_background.jpeg'
                    : 'assets/backgrounds/tablet_background.jpeg',
                fit: BoxFit.fitHeight,
              ),
            ),

            Positioned.fill(
              child: Container(
                color: AppColors.background,
              ),
            ),

            SizedBox(height: 20.h),

            // شعار التطبيق
            Center(
              child: Image.asset(
                'assets/Logo.png',
                height: 100.h,
              ),
            ),
          ],


    );
  }
}
