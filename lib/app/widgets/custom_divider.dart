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
    this.indent = 0,
    this.endIndent = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness.h,
            color: dividerColor ?? Get.theme.dividerColor,
            height: height.h,
            indent: indent,
            endIndent: 10.w, // Adds spacing between the line and text
          ),
        ),
        Container(

          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Get.theme.dividerColor,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness.h,
            color: dividerColor ?? Get.theme.dividerColor,
            height: height.h,
            indent: 10.w, // Adds spacing between the text and line
            endIndent: endIndent,
          ),
        ),
      ],
    );
  }
}
