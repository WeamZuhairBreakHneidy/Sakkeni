import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../core/controllers/BaseTabController.dart';

Widget buildHeaderTabs({
  required BaseTabController tabController,
  void Function(int index)? onTabSelected,
}) {
  return Obx(
        () => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("For Rent", 0, tabController, onTabSelected),
        SizedBox(width: 10.w),
        _tabButton("For Sale", 1, tabController, onTabSelected),
        SizedBox(width: 10.w),
        _tabButton("Off plan", 2, tabController, onTabSelected),
      ],
    ),
  );
}

Widget _tabButton(String label, int index, BaseTabController controller, void Function(int)? onTabSelected) {
  return GestureDetector(
    onTap: () {
      controller.selectedTab.value = index;
      if (onTabSelected != null) {
        onTabSelected(index); // الشاشة تقرر شو تعمل وقت الضغط
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: controller.selectedTab.value == index
            ? AppColors.tabtextselected
            : AppColors.tab,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.tab),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.tabtext,
          fontSize: 13.sp,
        ),
      ),
    ),
  );
}
