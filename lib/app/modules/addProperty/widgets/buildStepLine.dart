import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildStepLine({required bool isFilled}) => Container(
  width: 20.w,
  height: 2.h,
  color: isFilled ? const Color(0xFF294741) : Colors.grey.shade300,
  margin: EdgeInsets.symmetric(horizontal: 4.w),
);
