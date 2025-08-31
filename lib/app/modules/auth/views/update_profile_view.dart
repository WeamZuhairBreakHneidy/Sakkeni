// ... (Your existing code)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends StatelessWidget {
  final UpdateProfileController controller =
  Get.find<UpdateProfileController>();

  UpdateProfileView({super.key});

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      controller.imageFile.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  children: [
                    Text(
                      "labels_profile".tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(height: 1, color: Colors.grey),
              ),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 28.w,vertical: 15.h),
                  child: Column(
                    children: [
                      // Avatar with Edit Button
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Obx(() {
                              final user = controller.user.value;
                              return CircleAvatar(
                                radius: 75.r,
                                backgroundImage:
                                controller.imageFile.value != null
                                    ? FileImage(controller.imageFile.value!)
                                    : (user?.profilePicturePath != null &&
                                    user!.profilePicturePath!
                                        .isNotEmpty)
                                    ? NetworkImage(
                                  '${ApiService().baseUrl}/${user.profilePicturePath!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                )
                                    : AssetImage(
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? "assets/backgrounds/default_black.png"
                                      : "assets/backgrounds/default.png",
                                ) as ImageProvider,
                              );
                            }),
                          ),
                          Positioned(
                            top: -10.h,
                            right: -10.w,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gray2.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      50.verticalSpace,
                      // First & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: InputTextFormField(
                              textEditingController: controller.first_name,
                              labelTextAboveTextField: Text(
                                "labels_first_name".tr,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              validatorType: ValidatorType.Name,
                              obsecure: false,
                              fillColor:
                              Theme.of(context).colorScheme.background,
                              borderColor: AppColors.border,
                            ),
                          ),
                          20.horizontalSpace,
                          Expanded(
                            child: InputTextFormField(
                              textEditingController: controller.last_name,
                              labelTextAboveTextField: Text(
                                "labels_last_name".tr,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              validatorType: ValidatorType.Name,
                              obsecure: false,
                              fillColor:
                              Theme.of(context).colorScheme.background,
                              borderColor: AppColors.border,
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      // Email
                      Obx(() {
                        final user = controller.user.value;
                        return InputTextFormField(
                          borderColor: AppColors.border,
                          textEditingController: TextEditingController(
                            text: user?.email ?? '',
                          ),
                          hintText: "labels_email".tr,
                          obsecure: false,
                          validatorType: ValidatorType.Email,
                          fillColor: Theme.of(context).colorScheme.background,
                          decoration: InputDecoration(
                            labelText: "labels_email".tr,
                            enabled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                          ),
                        );
                      }),
                      20.verticalSpace,
                      // Phone Number
                      InputTextFormField(
                        borderColor: AppColors.border,
                        textEditingController: controller.phone_number,
                        labelTextAboveTextField: Text(
                          "labels_phone_number".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        validatorType: ValidatorType.PhoneNumber,
                        obsecure: false,
                        fillColor: Theme.of(context).colorScheme.background,
                      ),
                      20.verticalSpace,
                      // Address
                      InputTextFormField(
                        textEditingController: controller.address,
                        labelTextAboveTextField: Text(
                          "labels_address".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        validatorType: ValidatorType.Default,
                        fillColor: Theme.of(context).colorScheme.background,
                        obsecure: false,
                        borderColor: AppColors.border,
                      ),
                      20.verticalSpace, // إضافة مسافة
                      // ------------------------------------------------
                      // Stripe Account ID field (New Code)
                      InputTextFormField(
                        textEditingController: controller.stripeAccountId,
                        labelTextAboveTextField: Text(
                          "labels_stripe_account_id".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        validatorType: ValidatorType.Default, // يمكنك استخدام Default أو إنشاء Validator خاص
                        fillColor: Theme.of(context).colorScheme.background,
                        obsecure: false,
                        borderColor: AppColors.border,
                      ),
                      // ------------------------------------------------
                      50.verticalSpace,
                      // Save Button or Loading
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(() {
                          return controller.isLoading.value
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
                            onPressed: controller.updateProfile,
                            child: Text(
                              "buttons_save_changes".tr,
                              style:
                              Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        }),
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildDivider() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: Divider(thickness: 1, color: Colors.grey[300], height: 5.h),
  );
}