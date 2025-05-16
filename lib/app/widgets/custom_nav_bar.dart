import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';

class CustomNavItems extends StatelessWidget {
  final List<String> navItems;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Function(int index)? onItemTap;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;

  final RxInt selectedIndex = 0.obs;

   CustomNavItems({
    Key? key,
    required this.navItems,
    this.textColor,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w400,
    this.onItemTap,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.spacing = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: navItems.asMap().entries.map((entry) {
        final index = entry.key;
        final title = entry.value;

        return GestureDetector(
          onTap: () {
            selectedIndex.value = index;
            if (onItemTap != null) {
              onItemTap!(index);
            }
          },
          child: Obx(() {

            bool isSelected = selectedIndex.value == index;

            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: spacing.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSelected ? (fontSize + 2).sp : fontSize.sp,
                  fontWeight: fontWeight,
                  color: textColor ?? Colors.black,
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}
