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
            "Add New Property",
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
          _buildTabLabel(context, "Select sell Type"),
          _buildTabSelector(
            sellTypeTabController,
            ['For Rent', 'For Sale', 'Off plan'],
                (index) => controller.selectedSellTypeIndex.value = index,
          ),
          _buildTabLabel(context, "Select Property Type"),
          _buildTabSelector(
            propertyTypeTabController,
            ['Apartment', 'Villa', 'Office'],
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
      )
  {
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
            context: context
        );
      } else if (propertyType == 1) {
        // Villa for Rent
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
            context: context
        );
      } else if (propertyType == 2) {
        // Office for Rent
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          isOffice: true,
            context: context
        );
      }
    } else if (sellType == 1) {
      // For Sale
      if (propertyType == 0) {
        // Apartment for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
            context: context
        );
      }
      else if (propertyType == 1) {
        // Villa for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          context: context
        );      } else if (propertyType == 2) {
        // Office for Sale
        return _buildFields(
          isApartment: true,
          showBuildingAndApartment: true,
          isOffice: true,
            context: context
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
    required BuildContext context
  }) {
    List<String> labels = ["Price", "Area", "Floor Number"];
    List<TextEditingController> controllers = [
      controller.priceController,
      controller.areaController,
      controller.floorNumberController,
    ];

    if (showBuildingAndApartment) {
      labels.addAll(["Building Number", "Apartment Number", "Bathrooms", "Balconies"]);
      controllers.addAll([
        controller.buildingNumberController,
        controller.apartmentNumberController,
        controller.bathroomsController,
        controller.balconiesController,
      ]);
    }

    if (!isOffice) {
      // Residential properties usually have bedrooms, bathrooms, balconies
      labels.addAll(["Bedrooms"]);
      controllers.addAll([
        controller.bedroomsController,

      ]);
    }

    labels.add("Lease Period value");
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

  Widget _buildSaleVillaFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildForm(
            ["Building Number", "Apartment Number", "Bathrooms", "Balconies"],
            [
              controller.buildingNumberController,
              controller.apartmentNumberController,
              controller.bathroomsController,
              controller.balconiesController,
            ],
          ),
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
            label: "Area",
            hint: "Select Area",
            controller: controller.areaController,
            keyboardType: ValidatorType.Number,
          ),
          _buildDateField(
            label: "Delivery Date",
            hint: "Select Delivery Date",
            controller: controller.deliveryDateController,
          ),
          _buildTextField(
            label: "First Payment",
            hint: "First Payment",
            controller: controller.firstPayController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "Overall Payment",
            hint: "Overall Payment",
            controller: controller.overallPaymentController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "Bathrooms",
            hint: "",
            controller: controller.bathroomsController,
            keyboardType:ValidatorType.Number, // Ensure numeric input
          ),
          _buildTextField(
            label: "Balconies",
            hint: "",
            controller: controller.balconiesController,
            keyboardType:ValidatorType.Number, // Ensure numeric input
          ),

          // استبدال حقول Payment Plan الفردية بـ PageView
          _buildTextField(
            label: "Bedrooms",
            hint: "Bedrooms",
            controller: controller.bedroomsController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "Floor Number",
            hint: "Floor Number",
            controller: controller.floorNumberController,
            keyboardType:ValidatorType.Number,
          ),
          _buildTextField(
            label: "Building Number",
            hint: "Building Number",
            controller: controller.buildingNumberController,
            keyboardType:ValidatorType.Number,
          ),
          _buildTextField(
            label: "Apartment Number",
            hint: "Apartment Number",
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
            label: "Area",
            hint: "Select Area",
            controller: controller.areaController,
            keyboardType: ValidatorType.Number,
          ),
          _buildDateField(
            label: "Delivery Date",
            hint: "Select Delivery Date",
            controller: controller.deliveryDateController,
          ),
          _buildTextField(
            label: "First Payment",
            hint: "First Payment",
            controller: controller.firstPayController,
            keyboardType:ValidatorType.Number,
          ),
          _buildTextField(
            label: "Overall Payment",
            hint: "Overall Payment",
            controller: controller.overallPaymentController,
            keyboardType: ValidatorType.Number,
          ),



          _buildTextField(
            label: "Floor Number",
            hint: "Floor Number",
            controller: controller.floorNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "Building Number",
            hint: "Building Number",
            controller: controller.buildingNumberController,
            keyboardType: ValidatorType.Number,
          ),
          _buildTextField(
            label: "Apartment Number",
            hint: "Apartment Number",
            controller: controller.apartmentNumberController,
            keyboardType: ValidatorType.Number,
          ),  _buildTextField(
            label: "bathrooms",
            hint: "bathrooms ",
            controller: controller.bathroomsController,
            keyboardType: ValidatorType.Number,
          ), _buildTextField(
            label: "balconies",
            hint: "balconies ",
            controller: controller.balconiesController,
            keyboardType: ValidatorType.Number,
          ),
          _buildPaymentPlanPageView(context),
        ],
      ),
    );
  }


  Widget _buildPaymentPlanPageView(BuildContext context) {
    // قائمة بويدجت كل مرحلة دفع
    final List<Widget> paymentPhases = [
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "Phase 0 (Down Payment)",
        // phaseController: controller.payPlanPhase0Controller, // Removed
        durationValueController: controller.payPlanDurationValue0Controller,
        durationUnitController: controller.payPlanDurationUnit0Controller,
        percentageController:
        controller.payPlanPercentage0Controller,
      ),
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "Phase 1 (During Construction)",
        // phaseController: controller.payPlanPhase1Controller, // Removed
        durationValueController: controller.payPlanDurationValue1Controller,
        durationUnitController: controller.payPlanDurationUnit1Controller,
        percentageController: controller.payPlanPercentage1Controller,
      ),
      _buildPaymentPhaseFields(
        context: context,
        phaseName: "Phase 2 (On Completion)",
        // phaseController: controller.payPlanPhase2Controller, // Removed
        durationValueController: controller.payPlanDurationValue2Controller,
        durationUnitController: controller.payPlanDurationUnit2Controller,
        percentageController: controller.payPlanPercentage2Controller,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Plan Details",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        10.verticalSpace,
        // PageView لحقول مراحل الدفع
        SizedBox(
          // PageView يحتاج لارتفاع محدد
          height: 350.h, // قد تحتاج لتعديل هذا الارتفاع بناءً على حجم المحتوى
          child: PageView.builder(
            controller: controller.paymentPageController,
            itemCount: paymentPhases.length,
            onPageChanged: (index) {
              controller.currentPaymentPageIndex.value =
                  index; // تحديث مؤشر الصفحة
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                // إضافة مساحة حول كل بطاقة
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
              // زر السابق
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
              // مؤشرات الصفحات (النقاط)
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
                        ? AppColors
                        .primary // نقطة الصفحة المختارة
                        : Colors.grey.withOpacity(
                      0.5,
                    ), // نقطة الصفحة غير المختارة
                  ),
                ),
              ),
              // زر التالي
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
        20.verticalSpace, // مسافة بعد قسم خطة الدفع
      ],
    );
  }

  Widget _buildPaymentPhaseFields({

    required String phaseName,
    required TextEditingController durationValueController,
    required TextEditingController durationUnitController,
    required TextEditingController percentageController,
    required BuildContext context

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
              // Removed _buildTextField for "Payment Phase"
              _buildTextField(
                label: "Duration Value",
                hint: "e.g., 1 (for 1 month)",
                controller: durationValueController,
                keyboardType:ValidatorType.Number,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Duration Unit",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  5.verticalSpace,
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:Theme.of(context).colorScheme.background,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    value: durationUnitController.text.isNotEmpty ? durationUnitController.text : null,
                    hint:  Text("Select Duration Unit"),
                    items: ['months', 'years', 'weeks']
                        .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
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
                label: "Percentage",
                hint: "e.g., 60%",
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
          hint: labels[i],
          controller: controllers[i],
          // تحديد نوع لوحة المفاتيح بناءً على التسمية
          keyboardType:  ValidatorType.Number
          // (labels[i].contains("Price") ||
          //     labels[i].contains("Area") ||
          //     labels[i].contains("Number") ||
          //     labels[i].contains("Bedrooms") ||
          //     labels[i].contains("Bathrooms") ||
          //     labels[i].contains("Balconies") ||
          //     labels[i].contains("Lease Period value") ||
          //     labels[i].contains("Garage") ||
          //     labels[i].contains("Yard Area"))

              // : TextInputType.text,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValidatorType keyboardType ,
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

  // Widget جديد لاختيار التاريخ
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
          "Lease Period Unit",
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
            hint: const Text("Select Lease Period Unit"),
            items:
            ['months', 'years', 'weeks']
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

  Widget _buildFurnishingToggle( BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Furnishing",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Obx(
              () => Row(
            children: [
              _buildFurnishingOption("Yes",context),
              12.horizontalSpace,
              _buildFurnishingOption("No",context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFurnishingOption(String value,BuildContext context) {
    final isSelected = controller.furnishing.value == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.furnishing.value = value,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF294741) :Theme.of(context).colorScheme.background,
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
              "Previous",
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
                  // No bedrooms, bathrooms, balconies
                }
              }

              else if (sellType == 1) {
                // Sale
                if (propertyType == 0) {
                  // Apartment (Sale) - currently same as rent fields
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
                  controller.areaController, // Added Area for Off Plan
                  controller.deliveryDateController,
                  controller.firstPayController,
                  controller.overallPaymentController,
                  controller.floorNumberController,
                ]);
                if (propertyType == 0) {
                  // Apartment (Off Plan)
                  requiredControllers.addAll([
                    controller.bedroomsController,
                    controller.bathroomsController, // Required for apartments
                    controller.balconiesController, // Required for apartments
                    controller.buildingNumberController,
                    controller.apartmentNumberController,
                  ]);
                } else if (propertyType == 1) {
                  // Villa (Off Plan)
                  requiredControllers.addAll([
                    controller.bedroomsController,
                    controller.bathroomsController, // Required for villas
                    controller.balconiesController, // Required for villas
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

              // تحقق إضافي من صلاحية خطة الدفع
              bool allRequiredPaymentPlanFieldsFilled = true;
              if (sellType == 2) {
                // إذا كان نوع البيع "Off Plan"
                // تحقق من Phase 0 (عادة ما تكون إلزامية)
                // Removed check for payPlanPhase0Controller.text
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

                // إذا كانت Phase 1 مملوءة جزئياً، تأكد من ملء جميع حقولها الفرعية
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
                // إذا كانت Phase 2 مملوءة جزئياً، تأكد من ملء جميع حقولها الفرعية
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
                  "Missing Fields",
                  "Please fill all required fields and complete any started payment plan phases before continuing.",
                  snackPosition: SnackPosition.TOP,

                );
                return;
              }

              // اجتياز جميع الفحوصات، انتقل للصفحة التالية
              Get.to(() => AdditionalInfoView(), binding: AddPropertyBinding());
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
    );
  }
}