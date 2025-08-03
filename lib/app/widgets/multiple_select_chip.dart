import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MultiSelectChips extends StatelessWidget {
  final List<String> options;
  final RxList<String> selectedItems;
  final Function(String item) onItemToggle;
  final Color selectedColor;
  final Color unselectedColor;
  final Color borderColor;
  final TextStyle ?textStyle;


  const MultiSelectChips({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onItemToggle,
    required this.selectedColor,
    required this.unselectedColor,
    required this.borderColor,
    required this.textStyle,
  });

  @override
    Widget build(BuildContext context) {
      return Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = selectedItems.contains(option.toLowerCase());

              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: () => onItemToggle(option.toLowerCase()),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : unselectedColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      option,
                      style: textStyle
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      });
    }
  }

