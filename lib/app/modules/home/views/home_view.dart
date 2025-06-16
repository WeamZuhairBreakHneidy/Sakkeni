import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/buildcard.dart';
import '../../../widgets/custom_nav_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background1,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: 110.76.w,
                        height: 90.h,
                        margin: EdgeInsets.only(top: 61.h),
                        child: Image.asset('assets/Logo.png'),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      indent: 30,
                      endIndent: 30,
                    ),
                    10.verticalSpace,
                    CustomNavItems(
                      navItems: ['Homes', 'Services', 'About Us', 'Log In'],
                      textColor: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      spacing: 15.0,
                      onItemTap: (index) => controller.onItemTap(index),
                    ),
                  ],
                ),
              ),
              // HorizontalFlipSections(
              //   frontImages: [
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //   ],
              //   backImages: [
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //   ],
              //   height: 200.h,
              //   viewportFraction: 0.4,
              //   flipDuration: Duration(seconds: 2),
              //   pageDuration: Duration(seconds: 4),
              // ),
              // HorizontalFlipSections(
              //   frontImages: [
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //   ],
              //   backImages: [
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //     'assets/backgrounds/background1.jpeg',
              //   ],
              //   height: 200.h,
              //   viewportFraction: 0.4,
              //   flipDuration: Duration(seconds: 2),
              //   pageDuration: Duration(seconds: 4),
              // ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
