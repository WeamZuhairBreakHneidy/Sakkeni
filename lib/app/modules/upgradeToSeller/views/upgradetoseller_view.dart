import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart'; // تأكد من المسار الصحيح
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/upgradetoseller_controller.dart';

class UpgradeToSellerView extends GetView<UpgradeToSellerController> {
  const UpgradeToSellerView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double contentHeight =
        screenHeight - 260.h; // 200 تقريبًا لحجم الشعار + الهوامش
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 61.h,
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              child: Center(
                child: SizedBox(
                  width: 110.76.w,
                  height: 90.h,
                  child: Image.asset(
                    'assets/Logo.png',
                    height: 75.h,
                    width: 150.w,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: contentHeight,
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 30.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'labels_become_a_seller'.tr,
                              textStyle: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          "messages_choose_account_type".tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 50.h),

                        _buildAccountTypeCard(
                          context,
                          icon: Icons.business_center,
                          title: "labels_commercial_account".tr,
                          description:
                          "messages_commercial_account_description".tr,
                          onTap:
                              () => controller.selectAccountType('Commercial'),
                        ),
                        SizedBox(height: 30.h),

                        _buildAccountTypeCard(
                          context,
                          icon: Icons.person,
                          title: "labels_personal_account".tr,
                          description:
                          "messages_personal_account_description".tr,
                          onTap: () => controller.selectAccountType('Personal'),
                        ),
                        // زر التأكيد
                        SizedBox(height: 40.h),
                        Obx(
                              () =>
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.h, right: 20.w),
                                  child: TextButton(
                                    onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.upgradeAccount,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.r),
                                      ),
                                    ),
                                    child:
                                    controller.isLoading.value
                                        ? SizedBox(
                                      height: 20.w,
                                      width: 20.w,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator
                                            .ballRotateChase,
                                        colors: [AppColors.primary],
                                        strokeWidth: 1,
                                      ),
                                    )
                                        : Text(
                                      "buttons_upgrade".tr,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildAccountTypeCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedAccountType.value ==
          title.split(' ')[0]; // يتطابق مع 'Commercial' أو 'Personal'

      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors
                .white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.primary
                  .withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28.w, color: AppColors.primary),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                            overflow: TextOverflow.ellipsis, // لو طويل جدًا، نقط
                          ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Icon(Icons.check_circle, color: AppColors.primary, size: 20.w),
                          ),
                      ],
                    ),

                    SizedBox(height: 5.h),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 13.sp, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}