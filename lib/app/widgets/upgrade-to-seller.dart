// File: upgrade-to-seller.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/theme/colors.dart';
import '../modules/auth/controllers/profile_controller.dart'; // تأكد من استيراد الـ ProfileController
import '../routes/app_pages.dart';

void showUpgradeToSellerDialog() {
  final profileController = Get.find<ProfileController>();

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
          "You must upgrade to a seller to access this feature.",
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
              Get.back(); // إغلاق مربع الحوار الحالي
              // الانتقال إلى شاشة الترقية، وعند العودة منها (بعد الانتهاء من الترقية)
              // يتم استدعاء fetchProfile لتحديث بيانات المستخدم.
              Get.toNamed(Routes.UPGRADETOSELLER)?.then((result) {
                // يمكنك تمرير 'true' من شاشة الترقية إذا كانت ناجحة
                if (result == true) {
                  profileController.fetchProfile();
                  print('ooooooo');// ⬅️ يحدث البيانات تلقائيًا بعد الرجوع
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
              "Upgrade to Seller",
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
            "Cancel",
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