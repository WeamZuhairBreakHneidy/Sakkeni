import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/addproperty/controllers/add_property_controller.dart';
import 'package:test1/app/modules/addproperty/controllers/sell_type_conrtoller.dart';
import 'package:test1/app/modules/addproperty/widgets/buildStepLine.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/validator_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/properties_tab.dart';
import '../bindings/add_property_binding.dart';
import '../controllers/countries_controller.dart';
import '../controllers/property_type_controller.dart';
import '../widgets/buildCheckCircle.dart';
import '../widgets/buildStepCircle.dart';
import 'additional_info_controller.dart';
import 'package:intl/intl.dart';

class ApartmentForRentView extends GetView<AddpropertyController> {
  ApartmentForRentView({super.key});

  final sellTypeTabController = Get.find<SellTypeController>();
  final propertyTypeTabController = Get.find<PropertyTypeController>();
  final countriesController = Get.find<CountriesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                30.verticalSpace,
                _buildTabSection(context),
                30.verticalSpace,
                Obx(() => _buildDynamicFields(context)),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19.r,
            backgroundColor: const Color(0xFF294741),
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
              color: const Color(0xFF294741),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabLabel(context, "labels_select_sell_type".tr),
          _buildTabSelector(
            sellTypeTabController,
            ['tabs_for_rent'.tr, 'tabs_for_sale'.tr, 'tabs_off_plan'.tr],
            (index) => controller.selectedSellTypeIndex.value = index,
          ),
          _buildTabLabel(context, "labels_select_property_type".tr),
          _buildTabSelector(
            propertyTypeTabController,
            ['labels_apartment'.tr, 'labels_villa'.tr, 'labels_office'.tr],
            (index) => controller.selectedPropertyTypeIndex.value = index,
          ),
        ],
      ),
    );
  }

  Widget _buildTabLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTabSelector(
    dynamic tabController,
    List<String> tabs,
    Function(int) onTabSelected,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TabSelector(
        controller: tabController,
        tabs: tabs,
        onTabSelected: onTabSelected,
      ),
    );
  }

  Widget _buildDynamicFields(BuildContext context) {
    final sellType = controller.selectedSellTypeIndex.value;
    final propertyType = controller.selectedPropertyTypeIndex.value;

    if (sellType == 0) {
      // For Rent
      if (propertyType == 0) {
        // Apartment for Rent
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          context: context,
        );
      } else if (propertyType == 1) {
        // Villa for Rent
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          context: context,
        );
      } else if (propertyType == 2) {
        // Office for Rent
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          isOffice: true,
          context: context,
        );
      }
    } else if (sellType == 1) {
      // For Sale
      if (propertyType == 0) {
        // Apartment for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          context: context,
        );
      } else if (propertyType == 1) {
        // Villa for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          context: context,
        );
      } else if (propertyType == 2) {
        // Office for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          isOffice: true,
          context: context,
        );
      }
    } else if (sellType == 2) {
      // Off Plan
      if (propertyType == 0) {
        // Apartment Off Plan
        return _buildOffPlanApartmentFields(context);
      } else if (propertyType == 1) {
        // Villa Off Plan
        return _buildOffPlanApartmentFields(context);
      } else if (propertyType == 2) {
        // Office Off Plan
        return _buildOffPlanOfficeFields(context);
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildFields({
    required bool isApartment,
    required bool showBuildingAndApartment,
    bool isOffice = false,
    required BuildContext context,
  }) {
    List<String> labels = [
      "labels_price".tr,
      "labels_area".tr,
      "labels_floor_number".tr,
    ];
    List<TextEditingController> controllers = [
      controller.priceController,
      controller.areaController,
      controller.floorNumberController,
    ];

    if (showBuildingAndApartment) {
      labels.addAll([
        "labels_building_number".tr,
        "labels_apartment_number".tr,
        "labels_bathrooms".tr,
        "labels_balconies".tr,
      ]);
      controllers.addAll([
        controller.buildingNumberController,
        controller.apartmentNumberController,
        controller.bathroomsController,
        controller.balconiesController,
      ]);
    }

    if (!isOffice) {
      labels.add("labels_bedrooms".tr);
      controllers.add(controller.bedroomsController);
    }

    labels.add("labels_lease_period_value".tr);
    controllers.add(controller.leasePeriodValueController);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildForm(labels, controllers),
          20.verticalSpace,
          _buildLeasePeriodUnitDropdown(),
          20.verticalSpace,
          _buildFurnishingToggle(context),
        ],
      ),
    );
  }

  Widget _buildOffPlanApartmentFields(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: "labels_area".tr,
            hint: "hint_text_choose_area".tr,
            controller: controller.areaController,
            keyboardType: ValidatorType.Number,
          ),
          _buildDateField(
            label: "labels_delivery_date".tr,
            hint: "hint_text_choose_delivery_date".tr,
            controller: controller.deliveryDateController,
          ),
          _buildTextField(
            label: "labels_first_payment".tr,
            hint: "hint_text_first_payment".tr,
            controller: controller.firstPayController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_overall_payment".tr,
            hint: "hint_text_overall_payment".tr,
            controller: controller.overallPaymentController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_bathrooms".tr,
            hint: "hint_text_bathrooms".tr,
            controller: controller.bathroomsController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_balconies".tr,
            hint: "hint_text_balconies".tr,
            controller: controller.balconiesController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_bedrooms".tr,
            hint: "hint_text_bedrooms".tr,
            controller: controller.bedroomsController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_floor_number".tr,
            hint: "hint_text_floor_number".tr,
            controller: controller.floorNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_building_number".tr,
            hint: "hint_text_building_number".tr,
            controller: controller.buildingNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_apartment_number".tr,
            hint: "hint_text_apartment_number".tr,
            controller: controller.apartmentNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildPaymentPlanPageView(context),
        ],
      ),
    );
  }

  Widget _buildOffPlanOfficeFields(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: "labels_area".tr,
            hint: "hint_text_choose_area".tr,
            controller: controller.areaController,
            keyboardType: ValidatorType.Number,
          ),
          _buildDateField(
            label: "labels_delivery_date".tr,
            hint: "hint_text_choose_delivery_date".tr,
            controller: controller.deliveryDateController,
          ),
          _buildTextField(
            label: "labels_first_payment".tr,
            hint: "hint_text_first_payment".tr,
            controller: controller.firstPayController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_overall_payment".tr,
            hint: "hint_text_overall_payment".tr,
            controller: controller.overallPaymentController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_floor_number".tr,
            hint: "hint_text_floor_number".tr,
            controller: controller.floorNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_building_number".tr,
            hint: "hint_text_building_number".tr,
            controller: controller.buildingNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_apartment_number".tr,
            hint: "hint_text_apartment_number".tr,
            controller: controller.apartmentNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_bathrooms".tr,
            hint: "hint_text_bathrooms".tr,
            controller: controller.bathroomsController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "labels_balconies".tr,
            hint: "hint_text_balconies".tr,
            controller: controller.balconiesController,
            keyboardType: ValidatorType.Number,
          ),
          _buildPaymentPlanPageView(context),
        ],
      ),
    );
  }

  Widget _buildPaymentPlanPageView(BuildContext context) {
    final List<Widget> paymentPhases = [
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "labels_phase_0".tr,
        durationValueController: controller.payPlanDurationValue0Controller,
        durationUnitController: controller.payPlanDurationUnit0Controller,
        percentageController: controller.payPlanPercentage0Controller,
      ),
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "labels_phase_1".tr,
        durationValueController: controller.payPlanDurationValue1Controller,
        durationUnitController: controller.payPlanDurationUnit1Controller,
        percentageController: controller.payPlanPercentage1Controller,
      ),
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "labels_phase_2".tr,
        durationValueController: controller.payPlanDurationValue2Controller,
        durationUnitController: controller.payPlanDurationUnit2Controller,
        percentageController: controller.payPlanPercentage2Controller,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "labels_payment_plan_details".tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        10.verticalSpace,
        SizedBox(
          height: 350.h,
          child: PageView.builder(
            controller: controller.paymentPageController,
            itemCount: paymentPhases.length,
            onPageChanged: (index) {
              controller.currentPaymentPageIndex.value = index;
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: paymentPhases[index],
              );
            },
          ),
        ),
        10.verticalSpace,
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.currentPaymentPageIndex.value > 0)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    controller.paymentPageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ...List.generate(
                paymentPhases.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        controller.currentPaymentPageIndex.value == index
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              if (controller.currentPaymentPageIndex.value <
                  paymentPhases.length - 1)
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    controller.paymentPageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
            ],
          ),
        ),
        20.verticalSpace,
      ],
    );
  }

  Widget _buildPaymentPhaseFields({
    required String phaseName,
    required TextEditingController durationValueController,
    required TextEditingController durationUnitController,
    required TextEditingController percentageController,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phaseName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
              10.verticalSpace,
              _buildTextField(
                label: "labels.duration_value".tr,
                hint: "hint_text.duration_value".tr,
                controller: durationValueController,
                keyboardType: ValidatorType.Number,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "labels.duration_unit".tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  5.verticalSpace,
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    value:
                        durationUnitController.text.isNotEmpty
                            ? durationUnitController.text
                            : null,
                    hint: Text("hint_text_choose_duration_unit".tr),
                    items:
                        ['labels_months'.tr, 'labels_years'.tr]
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        durationUnitController.text = val;
                      }
                    },
                  ),
                ],
              ),
              _buildTextField(
                label: "labels_percentage".tr,
                hint: "hint_text_percentage".tr,
                controller: percentageController,
                keyboardType: ValidatorType.Number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
    List<String> labels,
    List<TextEditingController> controllers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        labels.length,
        (i) => _buildTextField(
          label: labels[i],
          hint: "${labels[i].toLowerCase().replaceAll(' ', '_')}".tr,
          controller: controllers[i],
          keyboardType: ValidatorType.Number,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValidatorType keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          InputTextFormField(
            textEditingController: controller,
            obsecure: false,
            hintText: hint,
            fillColor: AppColors.white,
            borderColor: AppColors.border,
            validatorType: keyboardType,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(pickedDate);
                controller.text = formattedDate;
              }
            },
            child: AbsorbPointer(
              child: InputTextFormField(
                textEditingController: controller,
                obsecure: false,
                hintText: hint,
                validatorType: ValidatorType.Default,
                fillColor: AppColors.white,
                borderColor: AppColors.border,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeasePeriodUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "labels_lease_period_unit".tr,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        5.verticalSpace,
        Obx(
          () => DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            value:
                controller.leasePeriodUnit.value.isNotEmpty
                    ? controller.leasePeriodUnit.value
                    : null,
            hint: Text("hint_text_choose_lease_period_unit".tr),
            items:
                ['labels_months'.tr, 'labels_years'.tr]
                    .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                    )
                    .toList(),
            onChanged: (val) {
              if (val != null) {
                controller.leasePeriodUnit.value = val;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFurnishingToggle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "labels_furnished".tr,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Obx(
          () => Row(
            children: [
              _buildFurnishingOption("labels_yes".tr, context),
              12.horizontalSpace,
              _buildFurnishingOption("labels_no".tr, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFurnishingOption(String value, BuildContext context) {
    final isSelected = controller.furnishing.value == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.furnishing.value = value,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF294741)
                    : Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
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
              "buttons_previous".tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF294741),
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
              buildStepCircle(isFilled: true),
              buildStepLine(isFilled: false),
              buildStepCircle(isFilled: false),
            ],
          ),
          GestureDetector(
            onTap: () {
              final sellType = controller.selectedSellTypeIndex.value;
              final propertyType = controller.selectedPropertyTypeIndex.value;

              List<TextEditingController> requiredControllers = [];
              List<RxString> requiredRxStrings = [];

              if (sellType == 0) {
                // Rent
                requiredControllers.addAll([
                  controller.priceController,
                  controller.areaController,
                  controller.floorNumberController,
                  controller.leasePeriodValueController,
                ]);

                requiredRxStrings.addAll([
                  controller.leasePeriodUnit,
                  controller.furnishing,
                ]);

                if (propertyType == 0 || propertyType == 1) {
                  // Apartment or Villa
                  requiredControllers.addAll([
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                    controller.bedroomsController,
                    controller.bathroomsController,
                    controller.balconiesController,
                  ]);
                } else if (propertyType == 2) {
                  // Office
                  requiredControllers.addAll([
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                    controller.bathroomsController,
                    controller.balconiesController,
                  ]);
                }
              } else if (sellType == 1) {
                // Sale
                if (propertyType == 0) {
                  // Apartment (Sale)
                  requiredControllers.addAll([
                    controller.priceController,
                    controller.areaController,
                    controller.floorNumberController,
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                    controller.bedroomsController,
                    controller.bathroomsController,
                    controller.balconiesController,
                    controller.leasePeriodValueController,
                  ]);
                  requiredRxStrings.addAll([
                    controller.leasePeriodUnit,
                    controller.furnishing,
                  ]);
                } else if (propertyType == 1) {
                  // Villa (Sale)
                  requiredControllers.addAll([
                    controller.priceController,
                    controller.areaController,
                    controller.floorNumberController,
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                    controller.bedroomsController,
                    controller.bathroomsController,
                    controller.balconiesController,
                    controller.leasePeriodValueController,
                  ]);
                } else if (propertyType == 2) {
                  // Office (Sale)
                  requiredControllers.addAll([
                    controller.priceController,
                    controller.floorNumberController,
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                  ]);
                }
              } else if (sellType == 2) {
                // Off Plan
                requiredControllers.addAll([
                  controller.areaController,
                  controller.deliveryDateController,
                  controller.firstPayController,
                  controller.overallPaymentController,
                  controller.floorNumberController,
                ]);
                if (propertyType == 0) {
                  // Apartment (Off Plan)
                  requiredControllers.addAll([
                    controller.bedroomsController,
                    controller.bathroomsController,
                    controller.balconiesController,
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                  ]);
                } else if (propertyType == 1) {
                  // Villa (Off Plan)
                  requiredControllers.addAll([
                    controller.bedroomsController,
                    controller.bathroomsController,
                    controller.balconiesController,
                  ]);
                } else if (propertyType == 2) {
                  // Office (Off Plan)
                  requiredControllers.addAll([
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                  ]);
                }
              }

              final hasEmptyTextFields = requiredControllers.any(
                (c) => c.text.trim().isEmpty,
              );
              final hasEmptyRxStrings = requiredRxStrings.any(
                (s) => s.value.trim().isEmpty,
              );

              bool allRequiredPaymentPlanFieldsFilled = true;
              if (sellType == 2) {
                if (controller.payPlanDurationValue0Controller.text
                        .trim()
                        .isEmpty ||
                    controller.payPlanDurationUnit0Controller.text
                        .trim()
                        .isEmpty ||
                    controller.payPlanPercentage0Controller.text
                        .trim()
                        .isEmpty) {
                  allRequiredPaymentPlanFieldsFilled = false;
                }

                if (controller.payPlanDurationValue1Controller.text
                        .trim()
                        .isNotEmpty ||
                    controller.payPlanDurationUnit1Controller.text
                        .trim()
                        .isNotEmpty ||
                    controller.payPlanPercentage1Controller.text
                        .trim()
                        .isNotEmpty) {
                  if (controller.payPlanDurationValue1Controller.text
                          .trim()
                          .isEmpty ||
                      controller.payPlanDurationUnit1Controller.text
                          .trim()
                          .isEmpty ||
                      controller.payPlanPercentage1Controller.text
                          .trim()
                          .isEmpty) {
                    allRequiredPaymentPlanFieldsFilled = false;
                  }
                }

                if (controller.payPlanDurationValue2Controller.text
                        .trim()
                        .isNotEmpty ||
                    controller.payPlanDurationUnit2Controller.text
                        .trim()
                        .isNotEmpty ||
                    controller.payPlanPercentage2Controller.text
                        .trim()
                        .isNotEmpty) {
                  if (controller.payPlanDurationValue2Controller.text
                          .trim()
                          .isEmpty ||
                      controller.payPlanDurationUnit2Controller.text
                          .trim()
                          .isEmpty ||
                      controller.payPlanPercentage2Controller.text
                          .trim()
                          .isEmpty) {
                    allRequiredPaymentPlanFieldsFilled = false;
                  }
                }
              }

              if (hasEmptyTextFields ||
                  hasEmptyRxStrings ||
                  !allRequiredPaymentPlanFieldsFilled) {
                Get.snackbar(
                  "error_missing_field".tr,
                  "messages_complete_required_fields".tr,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              Get.to(() => AdditionalInfoView(), binding: AddPropertyBinding());
            },
            child: Text(
              "buttons_next".tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF294741),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
