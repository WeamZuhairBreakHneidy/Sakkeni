import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../modules/myServices/controllers/add_service_controller.dart';
import '../modules/services/controllers/services_controller.dart' show ServicesController;
import '../modules/services/models/service_item_model.dart';


class AddServiceDialog extends GetView<AddServiceController> {
  AddServiceDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add a new Service',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Select services, add a description, and upload photos.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 20.h),

                /// Services Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Services",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildServiceSection(),

                SizedBox(height: 20.h),

                /// Service Description Card
                Text(
                  "Service Description",
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.h),
                TextField(
                  maxLines: 5,
                  onChanged: controller.setDescription,
                  decoration: InputDecoration(
                    hintText: "Write something about your service...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),

                SizedBox(height: 20.h),

                SizedBox(height: 12.h),


                SizedBox(height: 20.h),

                /// Add Service Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Iconsax.add),
                    label: const Text("Add Service"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 6,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    onPressed: controller.isLoading.value ? null : controller.addService,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceItem service) {
    // Keep this as is
    final servicesController = Get.find<ServicesController>();
    return Obx(() {
      // ✅ التغيير هنا: التحقق من قيمة واحدة بدلاً من قائمة
      bool isSelected = controller.selectedServiceId.value == service.id;

      return InkWell(
        onTap: () => controller.toggleService(service.id),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                service.icon,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 22.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.background,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 20.w),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildServiceSection() {
    final servicesController = Get.find<ServicesController>();
    return Obx(() {
      if (servicesController.isLoading.value) {
        return SizedBox(
          height: 50.h,
          width: 50.w,
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleRipple,
            colors: [AppColors.primary],
          ),
        );
      }
      if (servicesController.categories.isEmpty) {
        return Text(
          "No services available.",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: servicesController.categories.map((category) {
          bool isCategoryExpanded = controller.expandedCategoryIds.contains(category.id);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => controller.toggleCategory(category.id),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                      Icon(
                        isCategoryExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              if (isCategoryExpanded)
                Column(
                  children: category.services.map((service) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: _buildServiceCard(service),
                    );
                  }).toList(),
                ),
              SizedBox(height: 16.h),
            ],
          );
        }).toList(),
      );
    });
  }
}