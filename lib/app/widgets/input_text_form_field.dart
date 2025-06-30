import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../data/services/validator_service.dart';

class InputTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final ValidatorType? validatorType;
  final InputDecoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool obsecure;
  final String? hintText;
  final Widget? labelTextAboveTextField;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final Widget? helper;
  final TextStyle? errorStyle;
  final String? otherValueForValidation;
  final Widget? counter;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  InputTextFormField({
    super.key,
    this.textEditingController,
    this.validatorType,
    this.decoration,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.errorStyle,
    this.otherValueForValidation,
    this.validator,
    required this.obsecure,
    this.labelTextAboveTextField,
    this.counter,
    this.helper,
    this.fillColor,
    this.borderColor,
  });

  final ValidationController validationController = Get.put(ValidationController());

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor = borderColor ?? Theme.of(context).colorScheme.primary; // اللون الافتراضي رمادي

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: TextFormField(
        controller: textEditingController,
        obscureText: obsecure,
        keyboardType: validatorType == ValidatorType.PhoneNumber ||
            validatorType == ValidatorType.Number
            ? TextInputType.number
            : TextInputType.text,
        decoration: decoration ??
            InputDecoration(
              errorStyle: errorStyle,
              filled: true,
              icon: icon,
              fillColor: fillColor ?? Theme.of(context).colorScheme.surface, // ✅ هنا التبديل
              helper: helper,
              counter: counter,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: effectiveBorderColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12.r,
              ),
              hintText: hintText,
              label: labelTextAboveTextField,
              floatingLabelBehavior: FloatingLabelBehavior.always, // ✅ هذا يجبر الليبل أن يبقى فوق
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12.r,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 16.w,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
        validator: validator ??
                (value) {
              switch (validatorType) {
                case ValidatorType.Name:
                  return validationController.validateName(value!);
                case ValidatorType.Email:
                  return validationController.validateEmail(value!);
                case ValidatorType.Password:
                  return validationController.validatePassword(value!);
                case ValidatorType.LoginPassword:
                  return validationController.validateLoginPassword(value!);
                case ValidatorType.PhoneNumber:
                  return validationController.validatePhoneNumber(value!);
                case ValidatorType.Number:
                  return validationController.validateNumber(value!);
                case ValidatorType.Code:
                  return validationController.validateResetCode(value!);
                default:
                  return validationController.validateDefault(value!);
              }
            },
      ),
    );
  }
}
