import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final double height;
  final String text;
  final Color? dividerColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final String fontFamily;
  final double indent;
  final double endIndent;

  const CustomDivider({
    Key? key,
    this.thickness = 2.0,
    this.height = 50.0,
    this.text = '',
    this.dividerColor,
    this.textColor,
    this.backgroundColor,
    this.fontSize = 17.0,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.fontFamily = 'DefaultFont',
     this.indent=0,  this.endIndent=0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          thickness: thickness.h,
          color: dividerColor ?? Get.theme.primaryColor,
          height: height.h,
          indent: indent,
          endIndent: endIndent,
        ),
        Container(
          color: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Get.theme.primaryColor,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}