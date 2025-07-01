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
      print('Selected image path: ${controller.imageFile.value!.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),

                  color: AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "View History",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.history,
                              color: AppColors.background1,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                30.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(height: 1.h, thickness: 1, color: Colors.grey),
                ),
                31.verticalSpace,

                // Avatar
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: GestureDetector(
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
                                    '${ApiService().baseUrl}/${user!.profilePicturePath!}?v=${DateTime.now().millisecondsSinceEpoch}',
                                  )
                                  : const AssetImage(
                                        "assets/backgrounds/default.png",
                                      )
                                      as ImageProvider,
                        );
                      }),
                    ),
                  ),
                ),

                // Form Fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                style: Theme.of(context).textTheme.bodyMedium!,
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

                      // Email (read-only)
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
                            labelStyle: TextStyle(),
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
                          style: Theme.of(context).textTheme.bodyMedium!,
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
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                        validatorType: ValidatorType.Default,
                        fillColor: AppColors.white,
                        obsecure: false,
                        borderColor: AppColors.border,
                      ),
                      55.verticalSpace,

                      // Save Button
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
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
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
                              );
                        }),
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
