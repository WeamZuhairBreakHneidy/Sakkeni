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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Important: Prevent resize

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              DeviceUtils.isPhone()
                  ? 'assets/backgrounds/phone_background.jpeg'
                  : 'assets/backgrounds/tablet_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Overlay Color Layer
          Positioned.fill(
            child: Container(color: AppColors.background1),
          ),

          // ✅ Scrollable Login Form Layer
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: controller.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 86.h),
                            Center(
                              child: Text(
                                'labels_welcome_to'.tr,
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                            SizedBox(height: 13.h),
                            Container(
                              height: 124.h,
                              margin: EdgeInsets.symmetric(horizontal: 76.w),
                              child: Image.asset('assets/Logo.png'),
                            ),
                            SizedBox(height: 110.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 48.w),
                              child: Column(
                                children: [
                                  InputTextFormField(
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
                                  SizedBox(height: 20.h),
                                  Obx(
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
                                          controller.isPasswordHidden.value
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
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: RememberMeCheckbox(
                                          isChecked: controller.rememberMe,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: TextButton(
                                          onPressed: () {
                                            // Forgot password logic
                                          },
                                          child: Text(
                                            'labels_forgot'.tr,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18.h),
                                  Obx(
                                        () => ResponsiveButton(
                                      onPressed: () {
                                        if (controller.loginFormKey.currentState!.validate()) {
                                          controller.login();
                                        }
                                      },
                                      clickable: !controller.isLoading.value,
                                      buttonStyle: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
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
                                  SizedBox(height: 61.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "labels_dont_have_an_account".tr,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 23.h),
                                  ResponsiveButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.REGISTER);
                                    },
                                    clickable: true,
                                    buttonStyle: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                      ),
                                    ),
                                    buttonWidth: Get.width,
                                    child: Text(
                                      'buttons_sign_up'.tr,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
