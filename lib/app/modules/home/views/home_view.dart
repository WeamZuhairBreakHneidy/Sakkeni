import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test1/app/core/theme/colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<RecommendedPropertiesController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the PageView to enable automatic scrolling
    final PageController pageController = PageController(viewportFraction: 0.85);

    // Timer for automatic scrolling
    Timer? carouselTimer;

    // Start auto-scrolling
    carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.page == controller.properties.length - 1) {
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });

    return Scaffold(
      drawer: Get.locale?.languageCode == 'ar' ? AppDrawer() : null,
      endDrawer: Get.locale?.languageCode == 'en' ? AppDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 110.76.w,
                      height: 90.h,
                      margin: EdgeInsets.only(top: 61.h),
                      child: Image.asset('assets/Logo.png'),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    indent: 30,
                    endIndent: 30,
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Recommended Properties',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            10.verticalSpace,
            Obx(() {
              if (controller.isLoading.value && controller.properties.isEmpty) {
                return _buildShimmerList();
              }
              final props = controller.properties;
              return SizedBox(
                height: 300.h,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: props.length,
                  itemBuilder: (context, index) {
                    final property = props[index];
                    final imageUrl = "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
                    final location = "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                    final propertyType = property.propertyType?.name ?? '';
                    final subType = property.residential?.residentialPropertyType?.name ?? property.commercial?.commercialPropertyType?.name ?? '';

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PROPERTY_DETAILS, arguments: property.id);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/backgrounds/default_placeholder.png',// ضع هنا صورة الديفولت
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                },
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16.h,
                              left: 12.w,
                              right: 12.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$propertyType • $subType",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: (index * 100).ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
                  },
                ),
              );
            }),
            20.verticalSpace,
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildShimmerList() {
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 230.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}