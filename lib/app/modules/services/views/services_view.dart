import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../../auth/controllers/profile_controller.dart';
import '../controllers/services_controller.dart';
import '../models/service_category_model.dart';
import '../models/service_item_model.dart';

class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeaderSection(context),
          /// Expanded body with rounded background
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.categories.isEmpty) {
                  return const Center(child: Text("No categories available"));
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 30.h),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category Label
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Text(
                              category.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14.r,
                                fontFamily: 'Roboto', // safe font
                              ),
                            ),
                          ),
                        ),

                        /// Horizontal scroll services
                        if (category.services.isNotEmpty)
                          SizedBox(
                            height: 220.h, // card height
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: category.services.length,
                              separatorBuilder: (_, __) => SizedBox(width: 12.w),
                              itemBuilder: (context, i) {
                                final service = category.services[i];
                                return _buildServiceCard(service);
                              },
                            ),
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// Service card widget
  Widget _buildServiceCard(ServiceItem service) {
    // Local reactive variable for scale
    final RxDouble scale = 1.0.obs;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => scale.value = 0.9, // pressed down
          onTapUp: (_) {
            scale.value = 1.0; // release
            // Navigate to detail page
            Get.toNamed(Routes.SERVICE_PROVIDERS, arguments: {
              "service": service.name,   // or service.id if API accepts id
            });
          },
          onTapCancel: () => scale.value = 1.0, // canceled press
          child: Obx(() => AnimatedScale(
            scale: scale.value,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Container(
              width: 160.w,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  children: [
                    // Image with fallback
                    Image.asset(
                      service.image.isNotEmpty ? service.image : "assets/backgrounds/services.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/backgrounds/services.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),

                    // Bottom overlay with service name
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: Text(
                                service.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(overflow: TextOverflow.visible),)
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Shield icon overlay
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(45),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.all(Radius.circular(100.r)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          service.icon,
                          size: 30,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );
  }

  /// Header widget
  Widget buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 61.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Logo
          Center(
            child: SizedBox(
              width: 110.76.w,
              height: 90.h,
              child: Image.asset('assets/Logo.png'),
            ),
          ),

          /// Row: Menu + Search + Filter + Add
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              10.horizontalSpace,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work_outline, color: Theme.of(context).colorScheme.surface),
                      8.horizontalSpace,
                      Text(
                        "Services for you",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.surface, fontSize: 18.r),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Container(
                    height: 3.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.white, AppColors.primary.withOpacity(0.4)],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
