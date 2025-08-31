// File: upgrade-to-seller.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/auth_controller.dart';

import '../core/theme/colors.dart';
import '../modules/auth/controllers/profile_controller.dart';
import '../routes/app_pages.dart';

void showUpgradeToSellerDialog() {
  final authController = Get.find<AuthController>();

  Get.defaultDialog(
    backgroundColor: AppColors.white,
    title: "",
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logowithcolor.png',
          width: 100.w,
          height: 80.h,
        ),
        SizedBox(height: 20.h),
        Text(
          "messages_upgrade_to_seller_required".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 25.h),
        SizedBox(
          width: 250.w,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.UPGRADETOSELLER)?.then((result) {
                if (result == true) {
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              "buttons_upgrade_to_seller".tr,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TextButton(
          onPressed: () {
            Get.back(); // إغلاق مربع الحوار
          },
          child: Text(
            "buttons_cancel".tr,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false, // يمنع إغلاق مربع الحوار بالنقر خارجًا
  );
}