import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/addproperty/controllers/add_property_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../controllers/amenties_controller.dart';
import '../widgets/buildCheckCircle.dart';
import '../widgets/buildStepCircle.dart';
import '../widgets/buildStepLine.dart';

class AdditionalInfoView extends GetView<AddpropertyController> {
  AdditionalInfoView({super.key});

  final amenitiesController = Get.put(AmenitiesController()); // أعلى الصفحة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),

            child: Column(
              children: [
                _buildHeader(context),
                30.verticalSpace,

                Text(
                  "Amenities",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Color(0xFF294741),
                  ),
                ),
                10.verticalSpace,
                Obx(() {
                  if (amenitiesController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final amenities =
                      amenitiesController.amenitiesModel.value.data;

                  return Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children:
                        amenities.map((datum) {
                          final isSelected = amenitiesController
                              .selectedAmenities
                              .contains(datum.name);

                          return GestureDetector(
                            onTap:
                                () => amenitiesController.toggleAmenity(
                                  datum.name,datum.id
                                ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFF294741)
                                        : Colors.white,
                                border: Border.all(color: Color(0xFF294741)),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                datum.name,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Color(0xFF294741),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }),

                30.verticalSpace,
                Text("additional_info", style: TextStyle(
                    fontSize: 14.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                InputTextFormField(
                  hintText: 'additional info',
                  textEditingController: controller.additionalInfo,
                  obsecure: false,
                  validatorType: ValidatorType.Default,
                  fillColor: AppColors.white,
                  borderColor: AppColors.border,
                ),
                40.verticalSpace,
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 19.r,
                backgroundColor: Color(0xFF294741),
                child: Image.asset(
                  'assets/icons/property_icon.png',
                  width: 25.w,
                  height: 25.h,
                  color: Colors.white,
                ),
              ),
              12.horizontalSpace,
              Text(
                "Add New Property",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Color(0xFF294741),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade300,
          indent: 50.w,
          endIndent: 16.w,
        ),
      ],
    );
  }



  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              "Previous",
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF294741),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              buildCheckCircle(),
              buildStepLine(isFilled: true),
              buildCheckCircle(),
              buildStepLine(isFilled: true),
              buildCheckCircle(),
              buildStepLine(isFilled: true),
              buildStepCircle(isFilled: true),
            ],
          ),
          GestureDetector(
            // onTap:controller.submitProperty,
            onTap: () {
              print('Price: ${controller.priceController.text}');
              print('Area: ${controller.areaController.text}');
              print('Bedrooms: ${controller.bedroomsController.text}');
              controller.submitProperty();
            },

            child: Text(
              "Finish",
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF294741),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
