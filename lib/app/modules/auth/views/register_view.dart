import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:test1/app/data/services/validator_service.dart';

import '../../../core/theme/colors.dart';

import '../../../core/util/device_utils.dart';

import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/responsive_buttun.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  // GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  DeviceUtils.isPhone()
                      ? 'assets/backgrounds/phone_background.jpeg'
                      : 'assets/backgrounds/tablet_background.jpeg',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // Opacity Layer
          Container(color: AppColors.background1),
          Form(
            key: controller.registerFormKey,
            child: ListView(
              children: [
                //Welcome to
                Container(
                  alignment: Alignment.center,
                  height: 36.h,
                  margin: EdgeInsets.only(top: 86.h).r,

                  child: Text(
                    'labels_welcome_to'.tr,

                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),

                //Logo
                Container(
                  alignment: Alignment.center,
                  height: 124.h,
                  margin:
                      EdgeInsets.only(top: 13.h, left: 76.w, right: 75.61.w).r,
                  child: Image.asset('assets/Logo.png'),
                ),
                //Register to continue
                Container(
                  padding: EdgeInsets.only(top: 13.h, left: 48.w, right: 48.w),
                  child: Text(
                    'labels_register_to_continue_using_the_app'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                // First Name
                Container(
                  margin: EdgeInsets.only(top: 15.h, left: 48.w, right: 48.w),
                  child: InputTextFormField(
                    suffixIcon: Icon(Icons.person, color: AppColors.primary),
                    obsecure: false,
                    hintText: 'hint_text_enter_your_first_name'.tr,
                    validatorType: ValidatorType.Name,
                    textEditingController: controller.firstNameController,
                  ),
                ),

                // Last Name
                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 48.w, right: 48.w),
                  child: InputTextFormField(
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                    obsecure: false,
                    hintText: 'hint_text_enter_your_last_name'.tr,
                    validatorType: ValidatorType.Name,
                    textEditingController: controller.lastNameController,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 48.w, right: 48.w),
                  child: InputTextFormField(
                    textEditingController: controller.emailController,

                    errorStyle: TextStyle(
                      height: 0,
                      color: Theme.of(context).colorScheme.error,
                    ),

                    suffixIcon: Icon(Icons.mail, color: AppColors.primary),
                    obsecure: false,
                    hintText: 'hint_text_enter_your_email'.tr,

                    validatorType: ValidatorType.Email,
                  ),
                ),

                //Password
                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 48.w, right: 48.w),
                  child: Obx(
                    () => InputTextFormField(
                      textEditingController: controller.passwordController,

                      obsecure: controller.isPasswordHidden.value,
                      hintText: 'hint_text_enter_your_password'.tr,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (controller.isPasswordHidden.value)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      ),

                      validatorType: ValidatorType.Password,
                    ),
                  ),
                ),
                //Password Confirmation
                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 48.w, right: 48.w),
                  child: Obx(
                    () => InputTextFormField(
                      textEditingController:
                          controller.passwordConfirmationController,

                      obsecure: controller.isPasswordHidden.value,
                      hintText: 'hint_text_enter_password_confirmation'.tr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != controller.passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //Button
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(top: 82.h, left: 48.w, right: 48.w),
                    child: ResponsiveButton(
                      onPressed: () {
                        if (controller.registerFormKey.currentState!
                            .validate()) {
                          controller.signup();
                        }
                      },
                      clickable: !controller.isLoading.value,

                      buttonStyle: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      buttonWidth: Get.width,
                      child: Text(
                        'buttons_sign_up'.tr,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
