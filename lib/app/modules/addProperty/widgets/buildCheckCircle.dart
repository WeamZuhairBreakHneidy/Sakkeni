import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCheckCircle() => Container(
  width: 22.w,
  height: 22.w,
  decoration: BoxDecoration(color: Color(0xFF294741), shape: BoxShape.circle),
  child: Center(child: Icon(Icons.check, color: Colors.white, size: 14)),
);
