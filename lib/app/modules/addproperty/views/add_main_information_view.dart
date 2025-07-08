import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/modules/addproperty/controllers/add_property_controller.dart';
import 'package:test1/app/modules/addproperty/views/apartment_for_rent_view.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/countries_model.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/multiple_select_chip.dart';
import '../bindings/add_property_binding.dart';
import '../controllers/countries_controller.dart';

class AddmaininformationVeiw extends GetView<AddpropertyController> {
  AddmaininformationVeiw({super.key});

  final countriesController = Get.find<CountriesController>();

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
              // HEADER
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 24.h,
                  bottom: 10.h,
                ),
                color: AppColors.white,
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
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Add New Property",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: const Color(0xFF294741),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 50.w, right: 16.w),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),

              30.verticalSpace,

              // Dropdowns
              Padding(
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
                      "No countries found",
                      style: TextStyle(fontSize: 14.sp),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Country Name",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            8.r,
                          ), // ممكن تغير القيمة للدائري أو المربع
                        ),
                        child: DropdownButton<Datum>(
                          isExpanded: true,
                          value: countriesController.selectedCountry.value,
                          hint: const Text("Choose a country"),
                          underline: SizedBox(),
                          // لإخفاء الخط الافتراضي تحت Dropdown
                          items:
                              countriesController.countriesModel.value.data.map(
                                (country) {
                                  return DropdownMenuItem<Datum>(
                                    value: country,
                                    child: Text(country.name ?? ''),
                                  );
                                },
                              ).toList(),
                          onChanged: (value) {
                            countriesController.selectCountry(value);
                          },
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Text(
                        "City Name",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: DropdownButton<Datum>(
                          isExpanded: true,
                          value: countriesController.selectedCity.value,
                          hint: const Text("Choose a city"),
                          underline: SizedBox(),
                          items:
                              countriesController.selectedCountry.value?.cities
                                  .map((city) {
                                    return DropdownMenuItem<Datum>(
                                      value: city,
                                      child: Text(city.name ?? ''),
                                    );
                                  })
                                  .toList() ??
                              [],
                          onChanged: (value) {
                            countriesController.selectCity(value);
                          },
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Exposure",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),

                      MultiSelectChips(
                        options: [
                          'North',
                          'South',
                          'East',
                          'West',
                          'Northeast',
                          'Northwest',
                          'Southeast',
                          'Southwest',
                        ],
                        selectedItems: controller.selectedDirections,
                        onItemToggle: controller.toggleDirection,
                        selectedColor: AppColors.tabtextselected,
                        unselectedColor: AppColors.tab,
                        borderColor: AppColors.tab,
                        textColor: AppColors.tabtext,
                      ),


                      SizedBox(height: 25.h),
                      Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      InputTextFormField(
                        hintText: 'Type an address',
                        textEditingController: controller.location,
                        obsecure: true,
                        validatorType: ValidatorType.Default,
                        fillColor: AppColors.white,
                        borderColor: AppColors.border,
                      ),
                    ],
                  );
                }),
              ),

               Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Previous
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Previous",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF294741),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// Step Progress
                    Row(
                      children: [
                        _buildCheckCircle(),
                        _buildStepLine(isFilled: true),
                        _buildStepCircle(isFilled: true),
                        _buildStepLine(isFilled: false),
                        _buildStepCircle(isFilled: false),
                      ],
                    ),

                    /// Next
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ApartmentForRentView(), binding: AddpropertyBinding());
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade400,
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

  Widget _buildCheckCircle() {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: const BoxDecoration(
        color: Color(0xFF294741),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.check, color: Colors.white, size: 14),
      ),
    );
  }

  Widget _buildStepCircle({required bool isFilled}) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFF294741), width: 2),
        shape: BoxShape.circle,
      ),
      child:
          isFilled
              ? Center(
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF294741),
                    shape: BoxShape.circle,
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildStepLine({required bool isFilled}) {
    return Container(
      width: 20.w,
      height: 2.h,
      color: isFilled ? const Color(0xFF294741) : Colors.grey.shade300,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}
