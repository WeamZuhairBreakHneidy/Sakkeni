import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildStepCircle({required bool isFilled}) => Container(
  width: 20.w,
  height: 20.w,
  decoration: BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: Color(0xFF294741), width: 2),
    shape: BoxShape.circle,
  ),
  child:
  isFilled
      ? Center(
    child: Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: Color(0xFF294741),
        shape: BoxShape.circle,
      ),
    ),
  )
      : null,
);
