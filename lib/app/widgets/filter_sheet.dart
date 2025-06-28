import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/controllers/filter_controller.dart';
import '../core/theme/colors.dart';
import '../widgets/responsive_buttun.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(

        height: 619.h,
          padding: EdgeInsets.all(26.w),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter", style: Theme.of(context).textTheme.titleMedium),
                12.verticalSpace,


                _buildCustomDropdown(
                  label: "Country",
                  value: controller.selectedCountry.value,
                  items: controller.countries,
                  onChanged: (val) {
                    controller.selectedCountry.value = val!;
                  },
                  context: context
                ),

                12.verticalSpace,


                _buildCustomDropdown(
                  label: "City",
                  value: controller.selectedCity.value,
                  items: controller.cities,
                  onChanged: (val) {
                    controller.selectedCity.value = val!;
                  },
                  context: context
                ),
                12.verticalSpace,

                // Area
                Text("Area (m²)", style: Theme.of(context).textTheme.titleSmall),
                RangeSlider(


                  min: 0, max: 1000, divisions: 100,
                  labels: RangeLabels(
                    "${controller.minArea.value.toInt()}",
                    "${controller.maxArea.value.toInt()}",
                  ),
                  values: RangeValues(controller.minArea.value, controller.maxArea.value),
                  onChanged: (values) {
                    controller.minArea.value = values.start;
                    controller.maxArea.value = values.end;
                  },
                ),
                12.verticalSpace,


                // Price
                Text("Price (\$)", style: Theme.of(context).textTheme.titleSmall),
                RangeSlider(
                  min: 0, max: 2000000, divisions: 100,
                  labels: RangeLabels(
                    "${controller.minPrice.value.toInt()}",
                    "${controller.maxPrice.value.toInt()}",
                  ),
                  values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
                  onChanged: (values) {
                    controller.minPrice.value = values.start;
                    controller.maxPrice.value = values.end;
                  },
                ),
                12.verticalSpace,


                // Bathrooms
                Text("Bathrooms", style: Theme.of(context).textTheme.titleSmall),
                2.verticalSpace,
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: List.generate(6, (index) {
                    bool isMore = index == 5; // last one is "More"
                    int value = index + 1;
                    bool isSelected = isMore
                        ? controller.bathrooms.value == 0
                        : controller.bathrooms.value == value;

                    return GestureDetector(
                      onTap: () {
                        if (isMore) {
                          controller.bathrooms.value = 0; // clear filter
                        } else {
                          controller.bathrooms.value = value;
                        }
                      },
                      child: Container(
                        width: 35.w,
                        height: 35.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(

                          color: isSelected ? AppColors.background1 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.r),

                        ),
                        child: Text(
                          isMore ? "More" : "$value",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 10.r,
                          ),
                        ),
                      ),
                    );
                  }),
                )
    ,
                12.verticalSpace,

                // Balconies
                Text("Balconies", style: Theme.of(context).textTheme.titleSmall),
                2.verticalSpace,
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: List.generate(6, (index) {
                    bool isMore = index == 5; // the last one is "More"
                    int value = index + 1;
                    bool isSelected = isMore
                        ? controller.balconies.value == 0
                        : controller.balconies.value == value;

                    return GestureDetector(
                      onTap: () {
                        if (isMore) {
                          controller.balconies.value = 0; // clear filter
                        } else {
                          controller.balconies.value = value;
                        }
                      },
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.background1 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.r),

                        ),
                        child: Text(
                          isMore ? "More" : "$value",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 10.r,
                          ),
                        ),
                      ),
                    );
                  }),
                )
    ,
                SizedBox(height: 12.h),

                // Amenities
                Text("Amenities", style: Theme.of(context).textTheme.titleSmall),
                Wrap(
                  spacing: 6.w,
                  children: controller.amenities.map((amenity) {
                    return FilterChip(
                      label: Text(amenity, style: TextStyle(fontSize: 10.sp)),
                      selected: controller.selectedAmenities.contains(amenity),
                      onSelected: (_) {
                        controller.toggleAmenity(amenity);
                      },
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),

                // Is Furnished
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Is Furnished", style: Theme.of(context).textTheme.titleSmall),
                    Switch(
                      value: controller.isFurnished.value,
                      onChanged: (value) {
                        controller.isFurnished.value = value;
                      },

                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Search Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                       TextButton(
                         onPressed: () {
          controller.clearFilters();
          },
                         child:  Text(
                "Clear",
                style: Theme.of(context).textTheme.titleSmall,
              )
                      ,),
                      ResponsiveButton(
                        buttonWidth: 150.w,
                        buttonHeight: 40.h,
                        buttonStyle: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppColors.background1),
                        ),
                        onPressed: () => Get.back(),
                        clickable: true,
                        child: Text('Search', style: Theme.of(context).textTheme.bodySmall),
                      ),
                  ],

                ),
              ],
            ),
          );
        }),
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
          width: 50.w,
          child: Text(
            label,
            style:Theme.of(context).textTheme.titleSmall,
          ),
        ),
        20.horizontalSpace,
        Expanded(
          child: Container(
            height: 20.h,

            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value.isEmpty ? null : value,
                elevation: 0,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.transparent,),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style:Theme.of(context).textTheme.titleSmall,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }


}
