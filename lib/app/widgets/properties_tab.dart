import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/theme/colors.dart';
import '../core/controllers/BaseTabController.dart';

class TabSelector extends StatelessWidget {
  final BaseTabController controller;
  final void Function(int index)? onTabSelected;
  final List<String> tabs;

  const TabSelector({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          return Row(
            children: [
              _tabButton(tabs[index], index),
              if (index != tabs.length - 1) SizedBox(width: 10.w),
            ],
          );
        }),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () {
        onTabSelected?.call(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tabtextselected : AppColors.tab,
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
}
