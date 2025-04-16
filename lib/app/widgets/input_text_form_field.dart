import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../data/services/validator_service.dart';

class InputTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final ValidatorType? validatorType;
  final InputDecoration? decoration;
  final double? width; // Width of the field
  final double? height; // Height of the field
  final EdgeInsetsGeometry? margin; // Margin around the field
  final EdgeInsetsGeometry? padding; // Padding inside the field
  final bool obsecure;
  final String? hintText; // Hint text
  final Widget? labelTextAboveTextField; // Nullable label
  final Widget? prefixIcon; // Prefix icon
  final Widget? suffixIcon; // Suffix icon
  final Widget? icon; // Custom leading icon
  final Widget? helper;

  final Widget? counter;
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
    required this.obsecure,   this.labelTextAboveTextField, this.counter, this.helper,
  });

  final ValidationController validationController = Get.put(ValidationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Responsive width
      height: height, // Responsive height
      margin: margin , // Responsive margin
      padding: padding,  // Responsive padding
      child: TextFormField(
       
        controller: textEditingController,
        obscureText: obsecure,
        keyboardType: validatorType == ValidatorType.PhoneNumber ||
            validatorType == ValidatorType.Number
            ? TextInputType.number
            : TextInputType.text,



        decoration: decoration ??

            InputDecoration(


              filled: true,
              icon: icon,
              fillColor: Theme.of(context).colorScheme.surface,

              helper: helper,
              counter: counter,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Responsive border radius
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(

                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14.r),
              hintText: hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14.r),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,

            ),

        validator: (value) {
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

//For a label above the text field but but in in a column with start as a crossAxisAlignment
//   For label above the textFormField
//           if (labelTextAboveTextField != null) ...[  // Only show label if not null
//             Container(
//               padding: EdgeInsets.only(left: 10.w, bottom: 5.h ,right: 10.w),
//
//               child: labelTextAboveTextField,
//             ),
//           ],