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
        _tabButton("For Rent", 0, tabController),
        SizedBox(width: 10.w),
        _tabButton("For Sale", 1, tabController),
        SizedBox(width: 10.w),
        _tabButton("Off plan", 2, tabController),
      ],
    ),
  );
}

Widget _tabButton(String label, int index, TabControllerX tabController) {
  return GestureDetector(
    onTap: () {
      tabController.selectedTab.value = index;
      if (index == 0) Get.offNamed(Routes.RENT);
      if (index == 1) Get.offNamed(Routes.PURCHASE);
      if (index == 2) Get.offNamed(Routes.OFFPLANE);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      decoration: BoxDecoration(
        color:
            tabController.selectedTab.value == index
                ? AppColors.tabtextselected
                : AppColors.tab,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.tab),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:
              tabController.selectedTab.value == index
                  ? AppColors.tabtext
                  : AppColors.tabtext,
          // fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
      ),
    ),
  );
}
