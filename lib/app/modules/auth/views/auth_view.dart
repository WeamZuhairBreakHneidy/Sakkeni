import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/theme/colors.dart';

import '../../../core/util/device_utils.dart';
import '../../../data/services/validator_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/remember_me_checkbox.dart';

import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/responsive_buttun.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

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
            key: controller.loginFormKey,
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

                //Email
                Container(
                  margin: EdgeInsets.only(top: 110.h, left: 48.w, right: 48.w),
                  child: InputTextFormField(
                    textEditingController: controller.emailController,

                    errorStyle: TextStyle(
                      height: 0,
                      color: Theme.of(context).colorScheme.error,
                    ),

                    suffixIcon: Icon(Icons.mail, color: AppColors.primary),
                    obsecure: false,
                    hintText: 'hint_text_enter_your_email'.tr,
                    helper: Text(''),

                    validatorType: ValidatorType.Email,
                  ),
                ),

                //Password
                Container(
                  margin: EdgeInsets.only(left: 48.w, right: 48.w),
                  child: Obx(
                    () => InputTextFormField(
                      textEditingController: controller.passwordController,
                      errorStyle: const TextStyle(
                        height: -1,
                        color: Colors.transparent,
                      ),
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

                      validatorType: ValidatorType.LoginPassword,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 48).w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me Checkbox
                      Flexible(
                        flex: 1,
                        child: RememberMeCheckbox(
                          isChecked: controller.rememberMe,
                        ),
                      ),

                      // Forgot Password Button
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            // Forgot Password logic
                          },
                          child: Text(
                            'labels_forgot'.tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Button
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(top: 18.h, left: 48.w, right: 48.w),
                    child: ResponsiveButton(
                      onPressed: () {
                        if (controller.loginFormKey.currentState!.validate()) {
                          controller.login();
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
                        'buttons_login'.tr,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 61.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "labels_dont_have_an_account".tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 23.h, left: 48.w, right: 48.w),
                  child: ResponsiveButton(
                    onPressed: () {
                      Get.toNamed(Routes.REGISTER);
                    },
                    clickable: true,

                    buttonStyle: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
