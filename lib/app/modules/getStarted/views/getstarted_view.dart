import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/responsive_buttun.dart';
class GetstartedView extends StatelessWidget {
  const GetstartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                // color: Theme.of(context).hintColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: 150.76.w,
                        height: 90.h,
                        margin: EdgeInsets.only(top: 61.h),
                        child: Image.asset('assets/Logo.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/backgrounds/background1.jpeg'),
                      fit: BoxFit.cover,
                    ),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),

                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.15,
                          vertical: 44.4.h,
                        ),
                        width: double.infinity,
                        child: Text(
                          "Discover a place you'll call Home.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 580.h),
                        child: ResponsiveButton(
                          onPressed: () {
                            Get.toNamed(Routes.HOME);
                          },
                          clickable: true,
                          margin: EdgeInsets.symmetric(
                            horizontal: 120.w,
                            vertical: 10.h,
                          ),

                          buttonStyle: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.background,
                            ),
                            overlayColor: WidgetStatePropertyAll(
                              AppColors.background,
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 10.r),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                          buttonWidth: Get.width,
                          buttonHeight:
                              MediaQuery.of(context).size.width * 0.12,

                          child: Text(
                            'Get Started'.tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
