import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../data/models/subscription_plan_model.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../services/controllers/services_controller.dart';
import '../controllers/upgrade_to_service_provider_controller.dart';
import '../controllers/subscription_plan_controller.dart';

class UpgradeToServiceProviderView
    extends GetView<UpgradeToServiceProviderController> {
  UpgradeToServiceProviderView({super.key});
  final servicesController = Get.put(ServicesController());

  /// خريطة أيقونات الخدمات
  final Map<String, IconData> serviceIcons = {
    "Fixes and Repairs": Icons.build,
    "Cleaning": Icons.cleaning_services,
    "Plumbing": Icons.plumbing,
    "Flooring": Icons.layers,
    "Painting & Finishing": Icons.format_paint,
    "Carpenter": Icons.carpenter,
    "Metalwork": Icons.hardware,
    "Deep Cleaning": Icons.clean_hands,
    "Regular Cleaning": Icons.cleaning_services,
    "Water Tank Cleaning": Icons.water_drop,
    "Plumber": Icons.plumbing,
    "Sewage unclogging": Icons.block,
    "Tiler": Icons.layers,
    "Interior": Icons.palette,
    "Exterior": Icons.format_paint,
    "Electrician": Icons.electrical_services,
    "Moving & Transport": Icons.local_shipping,
    "Garden Upkeep": Icons.local_florist,
    "Solar": Icons.solar_power,
    "Generators": Icons.power,
    "Moving Service": Icons.local_shipping,
    "Irrigation": Icons.water_damage,
    "Pest Control": Icons.pest_control,
  };

  /// خريطة أيقونات الباقات
  final Map<String, IconData> planIcons = {
    "Monthly": Icons.calendar_view_month,
    "Yearly": Icons.calendar_today,
  };

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.put(SubscriptionPlanController());

    double screenHeight = MediaQuery.of(context).size.height;
    double contentHeight = screenHeight - 260.h;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Logo
            Padding(
              padding: EdgeInsets.only(
                top: 61.h,
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              child: Center(
                child: SizedBox(
                  width: 110.76.w,
                  height: 90.h,
                  child: Image.asset(
                    'assets/Logo.png',
                    height: 75.h,
                    width: 150.w,
                  ),
                ),
              ),
            ),

            /// Main container
            SizedBox(
              height: contentHeight,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 30.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Title
                        SizedBox(height: 20.h),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'Become a Service Provider!',
                              textStyle: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          "Choose your subscription plan, select services, and add a description.",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 40.h),

                        /// Subscription Plan
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Subscription Plan",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Obx(() {
                          if (subscriptionController.isLoading.value) {
                            return SizedBox(
                              height: 50.h,
                              width: 50.w,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballRotateChase,
                                colors: [AppColors.primary],
                              ),
                            );
                          }

                          if (subscriptionController.subscriptionPlanModel.value.data.isEmpty) {
                            return Text(
                              "No subscription plans available.",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey[600]),
                            );
                          }

                          return Column(
                            children: subscriptionController.subscriptionPlanModel.value.data
                                .map((plan) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: _buildDynamicPlanCard(
                                plan: plan,
                                controller: subscriptionController,
                              ),
                            ))
                                .toList(),
                          );
                        }),

                        SizedBox(height: 40.h),

                        /// Services
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
                        Obx(() {
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
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey[600]),
                            );
                          }

                          return Column(
                            children: servicesController.categories
                                .map((service) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: _buildServiceCard(
                                serviceId: service.id,
                                name: service.name,
                              ),
                            ))
                                .toList(),
                          );
                        }),

                        SizedBox(height: 40.h),

                        /// Description
                        TextField(
                          maxLines: 3,
                          onChanged: controller.setDescription,
                          decoration: InputDecoration(
                            hintText: "Write something about your services...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),

                        /// Upgrade Button
                        SizedBox(height: 40.h),
                        Obx(
                              () => Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h, right: 20.w),
                              child: TextButton(
                                onPressed: controller.isLoading.value ? null : controller.upgradeToServiceProvider,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? SizedBox(
                                  height: 20.w,
                                  width: 20.w,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballRotateChase,
                                    colors: [AppColors.primary],
                                    strokeWidth: 1,
                                  ),
                                )
                                    : Text(
                                  "Upgrade",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// Dynamic Plan Card
  Widget _buildDynamicPlanCard({
    required Datum plan,
    required SubscriptionPlanController controller,
  }) {
    return Obx(() {
      bool isSelected = this.controller.selectedPlanId.value == plan.id;

      return InkWell(
        onTap: () => this.controller.selectPlan(plan.id ?? 0),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                planIcons[plan.name] ?? Icons.subscriptions,
                size: 28.w,
                color: AppColors.primary,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.name ?? "Unnamed Plan",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: AppColors.primary, size: 20.w),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Service card
  Widget _buildServiceCard({required int serviceId, required String name}) {
    return Obx(() {
      bool isSelected = controller.selectedServices.contains(serviceId);

      return InkWell(
        onTap: () => controller.toggleService(serviceId),
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
                serviceIcons[name] ?? Icons.miscellaneous_services,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 22.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  name,
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
}