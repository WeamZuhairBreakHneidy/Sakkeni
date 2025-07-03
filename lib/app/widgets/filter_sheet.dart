import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../core/theme/colors.dart';
import '../data/enums/property_type_enum.dart';
import '../modules/home/controllers/filter_controller.dart';
import '../modules/properties/controllers/properties_offplan_controller.dart';
import '../modules/properties/controllers/properties_purchase_controller.dart';
import '../modules/properties/controllers/properties_rent_controller.dart';
import '../widgets/responsive_buttun.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());
// In your home screen or property listing screen:
    Get.lazyPut(() => RentController());
    Get.lazyPut(() => PurchaseController());
    Get.lazyPut(() => OffPlanController());
    /// Build the list of pages dynamically based on property type,
    /// putting rent extras and offplan extras at the end.
    List<Widget> buildPages() {
      final pages = <Widget>[
        _buildPropertyTypePage(controller, context), // Always first
        _buildCommonFiltersPage(controller, context),
        _buildAmenitiesPage(controller, context),
      ];

      // Append rent extras at the end only if selected
      if (controller.selectedPropertyType.value == PropertyTypeEnum.rent) {
        pages.add(_buildRentExtrasPage(controller, context));
      }

      // Append offplan extras at the end only if selected
      if (controller.selectedPropertyType.value == PropertyTypeEnum.offplan) {
        pages.add(_buildOffPlanExtrasPage(controller, context));
      }

      return pages;
    }

    /// Count pages excluding the property type page (index 0)
    int pageCount() => buildPages().length - 1;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      child: Column(
        children: [
          // HEADER
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text("Filter", style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Obx(() {
                  final totalPages = pageCount();
                  final currentPage = controller.currentPage.value;
                  return Row(
                    children: [
                      Icon(Icons.arrow_left, size: 14.r),
                      Text(
                        (currentPage > 0 && currentPage <= totalPages)
                            ? "$currentPage/$totalPages"
                            : "",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Icon(Icons.arrow_right, size: 14.r),
                    ],
                  );
                }),
              ],
            ),
          ),

          // PAGE VIEW
          Expanded(
            child: Obx(() {
              final pages = buildPages();
              return PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                physics: controller.currentPage.value == 0
                    ? const NeverScrollableScrollPhysics()
                    : null,
                children: pages,
              );
            }),
          ),

          // STATIC BUTTONS
          Obx(() {
            final page = controller.currentPage.value;
            if (page == 0) {
              return const SizedBox.shrink();
            } else {
              return Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: controller.clearFilters,
                      child: Text("Clear", style: Theme.of(context).textTheme.titleSmall),
                    ),
                    ResponsiveButton(
                      buttonWidth: 150.w,
                      buttonHeight: 40.h,
                      buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(AppColors.background1),
                      ),
                      onPressed: () async {
                        final filterBody = controller.buildFilterBody();
                        switch (controller.selectedPropertyType.value) {
                          case PropertyTypeEnum.rent:
                            await Get.find<RentController>().fetchFilteredProperties(
                              filterBody: filterBody,
                              force: true,
                            );
                            break;
                          case PropertyTypeEnum.purchase:
                            await Get.find<PurchaseController>().fetchFilteredProperties(
                              filterBody: filterBody,
                              force: true,
                            );
                            break;
                          case PropertyTypeEnum.offplan:
                            await Get.find<OffPlanController>().fetchFilteredProperties(
                              filterBody: filterBody,
                              force: true,
                            );
                            break;
                        }
                        Get.back();
                      },
                      clickable: true,
                      child: Text("Search", style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              );
            }
          }),


        ],
      ),
    );
  }

  /// Page 0: choose property type
  Widget _buildPropertyTypePage(FilterController controller, BuildContext ctx) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Choose Property Type", style: Theme.of(ctx).textTheme.titleMedium),
          20.verticalSpace,
          Wrap(
            spacing: 16.w,
            children: [
              _propertyTypeButton(controller, ctx, PropertyTypeEnum.purchase, "For Sale"),
              _propertyTypeButton(controller, ctx, PropertyTypeEnum.rent, "For Rent"),
              _propertyTypeButton(controller, ctx, PropertyTypeEnum.offplan, "Off Plan"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propertyTypeButton(FilterController controller, BuildContext ctx, PropertyTypeEnum type, String label) {
    return ElevatedButton(
      onPressed: () {
        controller.selectedPropertyType.value = type;
        // Jump immediately to the first filter page (index 1)
        controller.pageController.jumpToPage(1);
        controller.currentPage.value = 1;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(label, style: Theme.of(ctx).textTheme.bodySmall!.copyWith(color: Colors.white)),
    );
  }

  // --- The filter pages below remain unchanged ---

  Widget _buildCommonFiltersPage(FilterController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          _buildCustomDropdown(
              label: "Country",
              value: controller.selectedCountry.value,
              items: controller.countries,
              onChanged: (val) => controller.onCountrySelected(val!),
              context: context),
          30.verticalSpace,
          _buildCustomDropdown(
              label: "City",
              value: controller.selectedCity.value,
              items: controller.cities,
              onChanged: (val) => controller.selectedCity.value = val!,
              context: context),
          30.verticalSpace,
          Text("Area (m²)", style: Theme.of(context).textTheme.titleSmall),
          Obx(() => Text(
              "${controller.minArea.value.toInt()} - ${controller.maxArea.value.toInt()} m²",
              style: Theme.of(context).textTheme.labelSmall)),
          RangeSlider(
              min: 0,
              max: 2000,
              divisions: 100,
              values: RangeValues(controller.minArea.value, controller.maxArea.value),
              labels: RangeLabels(controller.minArea.value.toInt().toString(),
                  controller.maxArea.value.toInt().toString()),
              onChanged: (values) {
                controller.minArea.value = values.start;
                controller.maxArea.value = values.end;
              }),
          30.verticalSpace,
          Text("Price (\$)", style: Theme.of(context).textTheme.titleSmall),
          Obx(() => Text(
              "\$${controller.minPrice.value.toInt()} - \$${controller.maxPrice.value.toInt()}",
              style: Theme.of(context).textTheme.labelSmall)),
          RangeSlider(
              min: 0,
              max: 2000000,
              divisions: 100,
              values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
              labels: RangeLabels(controller.minPrice.value.toInt().toString(),
                  controller.maxPrice.value.toInt().toString()),
              onChanged: (values) {
                controller.minPrice.value = values.start;
                controller.maxPrice.value = values.end;
              }),
          30.verticalSpace,
          if (controller.selectedPropertyType.value != PropertyTypeEnum.offplan)
            Row(
              children: [
                Text("Is Furnished", style: Theme.of(context).textTheme.titleSmall),
                10.horizontalSpace,
                Switch(
                    value: controller.isFurnished.value,
                    onChanged: (v) => controller.isFurnished.value = v),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesPage(FilterController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Text("Bathrooms", style: Theme.of(context).textTheme.titleSmall),
          12.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(6, (index) {
              int val = index + 1;
              bool isMore = index == 5;
              bool isSelected = isMore
                  ? controller.bathrooms.value == 0
                  : controller.bathrooms.value == val;
              return GestureDetector(
                onTap: () => controller.bathrooms.value = isMore ? 0 : val,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.background1 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    isMore ? "More" : "$val",
                    style: isSelected
                        ? Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)
                        : Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              );
            }),
          ),
          20.verticalSpace,
          Text("Balconies", style: Theme.of(context).textTheme.titleSmall),
          12.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(6, (index) {
              int val = index + 1;
              bool isMore = index == 5;
              bool isSelected = isMore
                  ? controller.balconies.value == 0
                  : controller.balconies.value == val;
              return GestureDetector(
                onTap: () => controller.balconies.value = isMore ? 0 : val,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.background1 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    isMore ? "More" : "$val",
                    style: isSelected
                        ? Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)
                        : Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              );
            }),
          ),
          20.verticalSpace,
          Text("Amenities", style: Theme.of(context).textTheme.titleSmall),
          10.verticalSpace,
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: controller.amenities.map((amenity) {
              return FilterChip(
                backgroundColor: Colors.grey.shade300,
                label: Text(amenity, style: Theme.of(context).textTheme.titleMedium),
                selected: controller.selectedAmenities.contains(amenity),
                onSelected: (_) => controller.toggleAmenity(amenity),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRentExtrasPage(FilterController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Text("Lease Period Length", style: Theme.of(context).textTheme.titleSmall),
          Obx(() => Text(
              "${controller.leasePeriodLength.value} ${controller.leasePeriodUnit.value}",
              style: Theme.of(context).textTheme.labelSmall)),
          Slider(
              min: 1,
              max: 36,
              divisions: 35,
              value: controller.leasePeriodLength.value.toDouble(),
              onChanged: (val) => controller.leasePeriodLength.value = val.toInt()),
          20.verticalSpace,
          _buildCustomDropdown(
              label: "Unit",
              value: controller.leasePeriodUnit.value,
              items: ["Month", "Year"],
              onChanged: (v) => controller.leasePeriodUnit.value = v!,
              context: context),
        ],
      ),
    );
  }

  Widget _buildOffPlanExtrasPage(FilterController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Text("First Payment Range", style: Theme.of(context).textTheme.titleSmall),
          10.verticalSpace,
          Obx(() => RangeSlider(
              min: 0,
              max: 100000,
              divisions: 100,
              values: RangeValues(controller.minFirstPay.value, controller.maxFirstPay.value),
              labels: RangeLabels(
                  controller.minFirstPay.value.toInt().toString(),
                  controller.maxFirstPay.value.toInt().toString()),
              onChanged: (values) {
                controller.minFirstPay.value = values.start;
                controller.maxFirstPay.value = values.end;
              })),
          20.verticalSpace,
          Text("Delivery Date", style: Theme.of(context).textTheme.titleSmall),
          10.verticalSpace,
          Obx(() => ElevatedButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                controller.deliveryDate.value = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
            child: Text(
              controller.deliveryDate.value.isEmpty
                  ? "Select Date"
                  : controller.deliveryDate.value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ))

        ],
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required BuildContext context,
  }) {
    return Row(
      children: [
        SizedBox(width: 70.w, child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        20.horizontalSpace,
        Expanded(
          child: Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.grey.shade300,
                isExpanded: true,
                value: value.isEmpty ? null : value,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.transparent),
                items: items
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: Theme.of(context).textTheme.titleSmall),
                ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
