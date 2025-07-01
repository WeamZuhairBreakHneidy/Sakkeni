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
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: AppColors.white,
                child: Row(
                  children: [
                    Text(
                      "Profile",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "View History",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.history,
                        color: AppColors.background1,
                      ),
                      onPressed: () {},
                    ),
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
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: _pickImage,
                        child: Obx(() {
                          final user = controller.user.value;
                          return CircleAvatar(
                            radius: 100.r,
                            backgroundImage:
                                controller.imageFile.value != null
                                    ? FileImage(controller.imageFile.value!)
                                    : (user?.profilePicturePath != null &&
                                        user!.profilePicturePath!.isNotEmpty)
                                    ? NetworkImage(
                                      '${ApiService().baseUrl}/${user.profilePicturePath!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                    )
                                    : const AssetImage(
                                          "assets/backgrounds/default.png",
                                        )
                                        as ImageProvider,
                          );
                        }),
                      ),
                      30.verticalSpace,

                      // First & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: InputTextFormField(
                              textEditingController: controller.first_name,
                              labelTextAboveTextField: Text(
                                "First Name",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              validatorType: ValidatorType.Name,
                              obsecure: false,
                              fillColor: AppColors.white,
                              borderColor: AppColors.border,
                            ),
                          ),
                          20.horizontalSpace,
                          Expanded(
                            child: InputTextFormField(
                              textEditingController: controller.last_name,
                              labelTextAboveTextField: Text(
                                "Last Name",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              validatorType: ValidatorType.Name,
                              obsecure: false,
                              fillColor: AppColors.white,
                              borderColor: AppColors.border,
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,

                      // Email (Read-Only)
                      Obx(() {
                        final user = controller.user.value;
                        return InputTextFormField(
                          borderColor: AppColors.border,
                          textEditingController: TextEditingController(
                            text: user?.email ?? '',
                          ),
                          hintText: "E-mail",
                          obsecure: false,
                          validatorType: ValidatorType.Email,
                          fillColor: AppColors.white,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            enabled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: AppColors.white),
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
                          "Phone Number",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        validatorType: ValidatorType.PhoneNumber,
                        obsecure: false,
                        fillColor: AppColors.white,
                      ),
                      20.verticalSpace,

                      // Address
                      InputTextFormField(
                        textEditingController: controller.address,
                        labelTextAboveTextField: Text(
                          "Address",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        validatorType: ValidatorType.Default,
                        fillColor: AppColors.white,
                        obsecure: false,
                        borderColor: AppColors.border,
                      ),
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
                                  "Save Changes",
                                  style: Theme.of(context).textTheme.labelSmall,
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
