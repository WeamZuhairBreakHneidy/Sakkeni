import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../bindings/add_property_binding.dart';
import '../controllers/add_property_controller.dart';
import '../widgets/buildStepCircle.dart';
import '../widgets/buildStepLine.dart';
import 'add_main_information_view.dart';

class AddPropertyView extends GetView<AddpropertyController> {
  const AddPropertyView({super.key});

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);

    if (pickedFiles.length >= 3) {
      controller.selectedImages.value =
          pickedFiles.map((x) => File(x.path)).toList();
    } else {
      Get.snackbar("Note", "Please select at least 3 images.");
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
              // HEADER
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 24.h,
                  bottom: 10.h,
                ),
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF294741),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: Image.asset(
                            'assets/icons/property_icon.png',
                            color: Theme.of(context).colorScheme.background,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Add New Property",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: const Color(0xFF294741),
                      ),
                    ),
                  ],
                ),
              ),

              30.verticalSpace,

              // Image and Video Selection Area
              Expanded(
                // Use Expanded to give available space
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() {
                        final images = controller.selectedImages;
                        return images.isNotEmpty
                            ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: SizedBox(
                            height: 200.h, // ممكن تزيد الارتفاع إذا حبيت
                            child: PageView.builder(
                              itemCount: images.length,
                              controller: PageController(
                                viewportFraction: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      12.r,
                                    ),
                                    child: Image.file(
                                      images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: _pickImages,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Text(
                              "Upload at least 3 photos",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 20.h),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              // Spacer removed as Expanded takes care of space

              // Step Indicator and Navigation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Previous",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Step Progress
                    Row(
                      children: [
                        buildStepCircle(isFilled: true),
                        buildStepLine(isFilled: true),
                        buildStepCircle(isFilled: false),
                        buildStepLine(isFilled: false),
                        buildStepCircle(isFilled: false),
                        buildStepLine(isFilled: false),
                        buildStepCircle(isFilled: false),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        if (controller.selectedImages.length < 3) {
                          Get.snackbar(
                            "Images Required",
                            "Please upload at least 3 images before continuing.",
                          );
                          return;
                        }
                        // if (controller.selectedVideo.value == null) {
                        //   Get.snackbar(
                        //     "Video Required",
                        //     "Please upload 1 video before continuing.",
                        //   );
                        //   return;
                        // }

                        Get.to(
                              () => AddmaininformationVeiw(),
                          binding: AddPropertyBinding(),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF294741),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}