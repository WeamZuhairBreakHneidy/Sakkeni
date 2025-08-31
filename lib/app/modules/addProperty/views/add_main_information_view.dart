import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/modules/addproperty/views/apartment_for_rent_view.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/countries_model.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/mini_map_picker.dart';
import '../../../widgets/multiple_select_chip.dart';
import '../bindings/add_property_binding.dart';
import '../controllers/add_property_controller.dart';
import '../controllers/countries_controller.dart';
import '../widgets/buildCheckCircle.dart';
import '../widgets/buildStepCircle.dart';
import '../widgets/buildStepLine.dart';

class AddmaininformationVeiw extends GetView<AddpropertyController> {
  AddmaininformationVeiw({super.key});

  final countriesController = Get.find<CountriesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color:Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Obx(() {
                    if (countriesController.isLoading.value) {
                      return Center(
                        child: SizedBox(
                          width: 75,
                          height: 75,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballClipRotateMultiple,
                            colors: [AppColors.primary],
                            strokeWidth: 1,
                          ),
                        ),
                      );
                    }

                    if (countriesController.countriesModel.value.data.isEmpty) {
                      return Text(
                        "messages_no_countries_found".tr,
                        style: TextStyle(fontSize: 14.sp),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text(
                          "labels_country_name".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        _buildDropdown(
                          items: countriesController.countriesModel.value.data,
                          selectedValue:
                          countriesController.selectedCountry.value,
                          onChanged: (value) {
                            countriesController.selectCountry(value);
                            controller.selectedCountryId.value = value?.id;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "labels_city_name".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        _buildDropdown(
                          items:
                          countriesController
                              .selectedCountry
                              .value
                              ?.cities ??
                              [],
                          selectedValue: countriesController.selectedCity.value,
                          onChanged: (value) {
                            countriesController.selectCity(value);
                            controller.selectedCityId.value = value?.id;
                          },
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "labels_exposure".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        MultiSelectChips(
                          options: [
                            'labels_north'.tr,
                            'labels_south'.tr,
                            'labels_east'.tr,
                            'labels_west'.tr,
                            'labels_northeast'.tr,
                            'labels_northwest'.tr,
                            'labels_southeast'.tr,
                            'labels_southwest'.tr,
                          ],
                          selectedItems: controller.selectedDirections,
                          onItemToggle: controller.toggleDirection,
                          selectedColor: AppColors.tabtextselected,
                          unselectedColor: Theme.of(context).colorScheme.background,
                          borderColor: AppColors.tab,
                          textStyle:Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "labels_address".tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        InputTextFormField(
                          hintText: 'hint_text_type_an_address'.tr,
                          textEditingController: controller.location,
                          obsecure: false,
                          validatorType: ValidatorType.Default,
                          fillColor: Theme.of(context).colorScheme.background,
                          borderColor: AppColors.border,
                        ),
                        SizedBox(height: 10.h),
                        MiniMapPicker(),
                        SizedBox(height: 17.h),
                      ],
                    );
                  }),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "buttons_previous".tr,
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
                        buildStepCircle(isFilled: true),
                        buildStepLine(isFilled: false),
                        buildStepCircle(isFilled: false),
                        buildStepLine(isFilled: false),
                        buildStepCircle(isFilled: false),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        final countryId = controller.selectedCountryId.value;
                        final cityId = controller.selectedCityId.value;
                        final directions = controller.selectedDirections;
                        final locationText = controller.location.text.trim();
                        final latLng = controller.selectedLocation.value;

                        if (countryId == null) {
                          Get.snackbar(
                            "labels_missing_field".tr,
                            "messages_select_a_country".tr,
                          );
                          return;
                        }

                        if (cityId == null) {
                          Get.snackbar(
                            "labels_missing_field".tr,
                            "messages_select_a_city".tr,
                          );
                          return;
                        }

                        if (directions.isEmpty) {
                          Get.snackbar(
                            "labels_missing_field".tr,
                            "messages_select_at_least_one_exposure".tr,
                          );
                          return;
                        }

                        if (locationText.isEmpty) {
                          Get.snackbar(
                            "labels_missing_field".tr,
                            "messages_enter_the_address".tr,
                          );
                          return;
                        }

                        if (latLng == null) {
                          Get.snackbar(
                            "labels_missing_location".tr,
                            "messages_pick_a_location".tr,
                          );
                          return;
                        }

                        Get.to(
                              () => ApartmentForRentView(),
                          binding: AddPropertyBinding(),
                        );
                      },

                      child: Text(
                        "buttons_next".tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF294741),
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
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              12.horizontalSpace,
              Text(
                "labels_add_new_property".tr,
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

  Widget _buildDropdown({
    required List<Datum> items,
    required Datum? selectedValue,
    required void Function(Datum?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButton<Datum>(
        isExpanded: true,
        value: selectedValue,
        hint: Text("hint_text_choose".tr),
        underline: SizedBox(),
        items:
        items.map((item) {
          return DropdownMenuItem<Datum>(
            value: item,
            child: Text(item.name ?? ''),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}