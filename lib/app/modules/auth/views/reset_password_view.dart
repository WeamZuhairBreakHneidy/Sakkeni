import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../core/theme/colors.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final controller = Get.put(ResetPasswordController());

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 25.h,
                    ),
              color: Theme.of(context).colorScheme.background,

                    child: Text(
                      "Reset Password",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(
                      height: 1.h,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  50.verticalSpace,

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: InputTextFormField(
                      textEditingController:
                          controller.currentPasswordController,
                      labelTextAboveTextField: Text(
                        "Current Password",
                        style: Theme.of(context).textTheme.bodyMedium!
                      ),
                      obsecure: true,
                      validatorType: ValidatorType.Password,
                      fillColor: Theme.of(context).colorScheme.background,
                      borderColor: AppColors.border,
                    ),
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: InputTextFormField(
                      textEditingController: controller.newPasswordController,
                      // hintText: "New Password",
                      labelTextAboveTextField: Text(
                        "New Password",
                        style: Theme.of(context).textTheme.bodyMedium!
                      ),
                      obsecure: true,
                      validatorType: ValidatorType.Password,
                      fillColor:Theme.of(context).colorScheme.background,

                      borderColor: AppColors.border,
                    ),
                  ),
                  40.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: InputTextFormField(
                      textEditingController:
                          controller.confirmPasswordController,
                      labelTextAboveTextField: Text(
                        "Confirm Password",
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                      obsecure: true,
                      validatorType: ValidatorType.Password,
                      fillColor:            Theme.of(context).colorScheme.background,

                      borderColor: AppColors.border,
                    ),
                  ),
                  290.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        controller.isLoading.value
                            ? Center(
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  colors: [AppColors.primary],
                                  strokeWidth: 1,
                                ),
                              ),
                            )
                            : TextButton(
                              onPressed: controller.resetPassword,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 35.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                "Save Changes",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),

    );
  }
}
