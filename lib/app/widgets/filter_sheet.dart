import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/colors.dart';
import '../modules/home/controllers/filter_controller.dart';
import '../widgets/responsive_buttun.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      child: SizedBox(
        height: 620.h,
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Text("Filter", style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Obx(() => Row(
                    children: [
                      Icon(Icons.arrow_left, size: 14.sp),
                      Text("${controller.currentPage.value + 1}/2",
                          style: Theme.of(context).textTheme.labelSmall),
                      Icon(Icons.arrow_right, size: 14.sp)
                    ],
                  )),
                ],
              ),
            ),

            // PAGE VIEW
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  // FIRST PAGE
                  Obx(() => SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        _buildCustomDropdown(
                            label: "Country",
                            value: controller.selectedCountry.value,
                            items: controller.countries,
                            onChanged: (val) =>
                            controller.selectedCountry.value = val!,
                            context: context),
                        30.verticalSpace,
                        _buildCustomDropdown(
                            label: "City",
                            value: controller.selectedCity.value,
                            items: controller.cities,
                            onChanged: (val) =>
                            controller.selectedCity.value = val!,
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
                            values: RangeValues(controller.minArea.value,
                                controller.maxArea.value),
                            labels: RangeLabels(
                                controller.minArea.value.toInt().toString(),
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
                            values: RangeValues(controller.minPrice.value,
                                controller.maxPrice.value),
                            labels: RangeLabels(
                                controller.minPrice.value.toInt().toString(),
                                controller.maxPrice.value.toInt().toString()),
                            onChanged: (values) {
                              controller.minPrice.value = values.start;
                              controller.maxPrice.value = values.end;
                            }),
                        30.verticalSpace,
                        Row(
                          children: [
                            Text("Is Furnished",
                                style: Theme.of(context).textTheme.titleSmall),
                            10.horizontalSpace,
                            Switch(
                                value: controller.isFurnished.value,
                                onChanged: (v) =>
                                controller.isFurnished.value = v),
                          ],
                        ),

                      ],
                    ),
                  )),
                  // SECOND PAGE
                  Obx(() => SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text("Bathrooms",
                            style: Theme.of(context).textTheme.titleSmall),
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
                              onTap: () => controller.bathrooms.value =
                              isMore ? 0 : val,
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.background1
                                        : Colors.grey.shade300,
                                    borderRadius:
                                    BorderRadius.circular(10.r)),
                                child: Text(
                                  isMore ? "More" : "$val",
                                  style: isMore? Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white): Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            );
                          }),
                        ),
                        20.verticalSpace,
                        Text("Balconies",
                            style: Theme.of(context).textTheme.titleSmall),
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
                              onTap: () => controller.balconies.value =
                              isMore ? 0 : val,
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.background1
                                        : Colors.grey.shade300,
                                    borderRadius:
                                    BorderRadius.circular(10.r)),
                                child: Text(
                                  isMore ? "More" : "$val",
                                  style: isMore? Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white): Theme.of(context).textTheme.titleMedium,
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
                              label: Text(amenity, style: Theme.of(context).textTheme.titleMedium),
                              selected:
                              controller.selectedAmenities.contains(amenity),
                              onSelected: (_) {
                                controller.toggleAmenity(amenity);
                              },
                              visualDensity: VisualDensity.standard,
                            );
                          }).toList(),
                        ),

                      ],
                    ),
                  )),
                ],
              ),
            ),

            // STATIC BUTTONS
            Container(

              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: controller.clearFilters,
                      child: Text("Clear",
                          style: Theme.of(context).textTheme.titleSmall)),
                  ResponsiveButton(
                    buttonWidth: 150.w,
                    buttonHeight: 40.h,
                    buttonStyle: ButtonStyle(
                        backgroundColor:
                        WidgetStatePropertyAll(AppColors.background1)),
                    onPressed: () {

                        Get.back();

                    },
                    clickable: true,
                    child:  Text(
                        "Search",
                        style: Theme.of(context).textTheme.bodySmall)),

                ],
              ),
            )
          ],
        ),
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
        SizedBox(
          width: 70.w,
          child: Text(label, style: Theme.of(context).textTheme.titleSmall),
        ),
        20.horizontalSpace,
        Expanded(
          child: Container(
            height: 28.h,
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                    BorderSide(color: Theme.of(context).primaryColor))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value.isEmpty ? null : value,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Colors.transparent),
                items: items
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style: Theme.of(context).textTheme.titleSmall),
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
