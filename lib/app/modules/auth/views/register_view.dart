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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

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


          Positioned.fill(
            child: Container(color: AppColors.background1),
          ),


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
                        key: controller.registerFormKey,
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 48.w),
                              child: Column(
                                children: [
                                  SizedBox(height: 13.h),
                                  Text(
                                    'labels_register_to_continue_using_the_app'.tr,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(height: 15.h),
                                  InputTextFormField(
                                    suffixIcon: Icon(Icons.person, color: AppColors.primary),
                                    obsecure: false,
                                    hintText: 'hint_text_enter_your_first_name'.tr,
                                    validatorType: ValidatorType.Name,
                                    textEditingController: controller.firstNameController,
                                  ),
                                  SizedBox(height: 20.h),
                                  InputTextFormField(
                                    suffixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                                    obsecure: false,
                                    hintText: 'hint_text_enter_your_last_name'.tr,
                                    validatorType: ValidatorType.Name,
                                    textEditingController: controller.lastNameController,
                                  ),
                                  SizedBox(height: 20.h),
                                  InputTextFormField(
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
                                  SizedBox(height: 20.h),
                                  Obx(
                                        () => InputTextFormField(
                                      textEditingController: controller.passwordController,
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
                                          controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
                                        },
                                      ),
                                      validatorType: ValidatorType.Password,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Obx(
                                        () => InputTextFormField(
                                      textEditingController: controller.passwordConfirmationController,
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
                                  SizedBox(height: 82.h),
                                  Obx(
                                        () => ResponsiveButton(
                                      onPressed: () {
                                        if (controller.registerFormKey.currentState!.validate()) {
                                          controller.signup();
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
                                        'buttons_sign_up'.tr,
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
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
