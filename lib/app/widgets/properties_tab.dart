import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../modules/properties/controllers/properties_tab_controller.dart';
import '../routes/app_pages.dart';

Widget buildHeaderTabs() {
  final tabController = Get.find<TabControllerX>();
  tabController.updateTabFromRoute();

  return Obx(
        () => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("For Rent", 0, tabController, '${Routes.PropertiesUnifiedView}?type=rent'),
        SizedBox(width: 10.w),
        _tabButton("For Sale", 1, tabController, '${Routes.PropertiesUnifiedView}?type=purchase'),
        SizedBox(width: 10.w),
        _tabButton("Off plan", 2, tabController, '${Routes.PropertiesUnifiedView}?type=offplan'),

      ],
    ),
  );
}

Widget _tabButton(String label, int index, TabControllerX controller, String route) {
  return GestureDetector(
    onTap: () {
      controller.selectedTab.value = index;
      Get.offNamed(route);
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
