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
import '../controllers/amenties_controller.dart';
import '../controllers/countries_controller.dart';
import '../controllers/property_type_controller.dart';
import '../widgets/buildCheckCircle.dart';
import '../widgets/buildStepCircle.dart';
import 'additional_info_controller.dart';

class ApartmentForRentView extends GetView<AddpropertyController> {
  ApartmentForRentView({super.key});

  final sellTypeTabController = Get.find<SellTypeController>();
  final propertyTypeTabController = Get.find<PropertyTypeController>();
  final countriesController = Get.find<CountriesController>();

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
            child: Column(
              children: [
                _buildHeader(context),
                30.verticalSpace,
                _buildTabSection(context),
                30.verticalSpace,

                Obx(() => _buildDynamicFields()),
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
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
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
      style: Theme
          .of(
        context,
      )
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTabSelector(controller,
      List<String> tabs,
      Function(int) onTabSelected,) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TabSelector(
        controller: controller,
        tabs: tabs,
        onTabSelected: onTabSelected,
      ),
    );
  }

  Widget _buildDynamicFields() {
    final sellType = controller.selectedSellTypeIndex.value;
    final propertyType = controller.selectedPropertyTypeIndex.value;

    if (propertyType == 0) {
      // Apartment
      switch (sellType) {
        case 0:
          return _buildForm(
            [
              "Price",
              "area",
              "Lease Period value",
              "Lease Period unit",
              "Furnishing",
              "Floor Number",
              "Building Number",
              "Apartment Number",
              "Bedrooms",
              "Bathrooms",
              "balconies",
            ],
            [
              controller.priceController,
              controller.areaController,
              controller.leasePeriodValueController,
              controller.leasePeriodUnitController,
              controller.furnishingController,
              controller.floorNumberRentController,
              controller.buildingNumberRentController,
              controller.apartmentNumberRentController,
              controller.bedroomsController,
              controller.bathroomsController,
              controller.balconiesController,
            ],
          );
          print(controller.priceController);
        case 1:
          return _buildForm(
            [
              "Price",
              "area",
              "Furnishing",
              "Floor Number",
              "Building Number",
              "Apartment Number",
              "Bedrooms",
              "Bathrooms",
              "balconies",
            ],
            [
              controller.priceController,
              controller.areaController,
              controller.furnishingController,
              controller.floorNumberRentController,
              controller.buildingNumberRentController,
              controller.apartmentNumberRentController,
              controller.bedroomsController,
              controller.bathroomsController,
              controller.balconiesController,
            ],
          );
        case 2:
          return _buildForm(
            [
              "Delivery Date",
              "First Pay",
              "Overall Payment",
              "Pay Plan",
              "Floor Number",
              "Building Number",
              "Apartment Number",
            ],
            [
              controller.deliveryDateController,
              controller.firstPayController,
              controller.overallPaymentController,
              controller.payPlanController,
              controller.floorNumberOffPlanController,
              controller.buildingNumberOffPlanController,
              controller.apartmentNumberOffPlanController,
            ],
          );
      }
    } else if (propertyType == 1) {
      // Villa
      switch (sellType) {
        case 0:
          return _buildForm(
            [
              "Price",
              "Lease Period",
              "Payment pal",
              "Furnishing",
              "Bedrooms",
              "Floor Number",
            ],
            [
              controller.priceController,
              controller.leasePeriodController,
              controller.villaPaymentpalRentController,
              controller.villaFurnishingRentController,
              controller.villaBedroomsRentController,
              controller.villaFloorNumberRentController,
            ],
          );

        case 1:
          return _buildForm(
            ["Price", "Furnishing", "Bedrooms", "Floor Number"],
            [
              controller.priceController,
              controller.villaYardSaleController,
              controller.villaGarageSaleController,
              controller.villaBedroomSaleController,
            ],
          );
        case 2:
          return _buildForm(
            [
              "Delivery Date",
              "First Pay",
              "Overall Payment",
              "Pay Plan",
              "Bedrooms",
              "Floor Number",
            ],
            [
              controller.deliveryDateController,
              controller.firstPayController,
              controller.overallPaymentController,
              controller.payPlanController,
              controller.villaBedroomOffplanController,
              controller.floorNumberOffPlanController,
            ],
          );
      }
    } else if (propertyType == 2) {
      switch (sellType) {
        case 0: // For Rent (Office)
          return _buildForm(
            [
              "Price",
              "Lease Period",
              "Payment Plan",
              // Changed from "Payment Pal" for clarity if it's a plan
              "Furnishing",
              "Floor Number",
              "Building Number",
              "Office Area",
              // Added for office
            ],
            [
              controller.priceController,
              controller.leasePeriodController,
              controller.paymentPalController,
              // Re-using paymentPalController as per original, but consider a dedicated one if logic differs
              controller.furnishingController,
              // Re-using furnishingController
              controller.floorNumberRentController,
              controller.buildingNumberRentController,
              controller.officeAreaRentController,
              // New controller for office area
            ],
          );

        case 1: // For Sale
          return _buildForm(
            [
              "Price",
              "Furnishing",
              "Floor Number",
              "Building Number",
              "Apartment Number",
            ],
            [
              controller.priceController,
              controller.furnishingController,
              // بدلًا من officeFurnishedController
              controller.floorNumberSaleController,
              // بدلًا من officeMaintenanceController
              controller.buildingNumberSaleController,
              controller.apartmentNumberSaleController,
            ],
          );

        case 2: // Off Plan
          return _buildForm(
            [
              "Delivery Date",
              "First Pay",
              "Overall Payment",
              "Pay Plan",
              "Floor Number",
              "Building Number",
              "Apartment Number",
            ],
            [
              controller.deliveryDateController,
              controller.firstPayController,
              controller.overallPaymentController,
              controller.payPlanController,
              controller.floorNumberSaleController,
              // بدلًا من officeMaintenanceController
              controller.buildingNumberSaleController,
              controller.apartmentNumberSaleController,
            ],
          );
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildForm(List<String> labels,
      List<TextEditingController> controllers,) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          labels.length,
              (i) =>
              _buildTextField(
                label: labels[i],
                hint: labels[i],
                controller: controllers[i],
              ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
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
          validatorType: ValidatorType.Default,
          fillColor: AppColors.white,
          borderColor: AppColors.border,
        ),
        15.verticalSpace,
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
              buildStepCircle(isFilled: true),
              buildStepLine(isFilled: false),
              buildStepCircle(isFilled: false),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AdditionalInfoView(), binding: AddpropertyBinding());
            },

            child: Text(
              "Next",
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