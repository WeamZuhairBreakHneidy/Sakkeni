import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'package:test1/app/core/theme/colors.dart';

class HomeView extends GetView<RecommendedPropertiesController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(
      viewportFraction: 0.90,
    );

    Timer? carouselTimer;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (pageController.hasClients) {
          final currentPage = pageController.page?.round() ?? 0;
          if (currentPage == controller.properties.length - 1) {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      drawer: Get.locale?.languageCode == 'ar' ? AppDrawer() : null,
      endDrawer: Get.locale?.languageCode == 'en' ? AppDrawer() : null,
      body: Stack(
        children: [
          Container(
            height: 150.h,
            color: AppColors.primary,
            // Using a color for illustration
          ),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  height: 100.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50.h),
                          child: Image.asset(
                            'assets/Logo.png',
                            width: 110.76.w,
                            height: 120.h,
                          ),
                        ),
                      ),

                      /// Drawer Button
                      Positioned(
                        right: Get.locale?.languageCode == 'en' ? 0.w : null,
                        left: Get.locale?.languageCode == 'ar' ? 0.w : null,
                        child: Builder(
                          builder:
                              (context) => GestureDetector(
                            onTap: () {
                              if (Get.locale?.languageCode == 'ar') {
                                Scaffold.of(context).openDrawer();
                              } else {
                                Scaffold.of(context).openEndDrawer();
                              }
                            },
                            child: Container(
                              width: 35.w,
                              height: 35.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius:
                                Get.locale?.languageCode == 'en'
                                    ? BorderRadius.horizontal(
                                  left: Radius.circular(10.r),
                                )
                                    : BorderRadius.horizontal(
                                  right: Radius.circular(10.r),
                                ),
                              ),
                              child: Icon(
                                Icons.menu_open_sharp,
                                size: 20.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                15.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 40.h,
                          left: 10.w,
                          right: 45.w,
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h,
                          ),
                          child: Text(
                            'Properties You Might Like',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Obx(() {
                        if (controller.isLoading.value &&
                            controller.properties.isEmpty) {
                          return _buildShimmerList();
                        }

                        final props = controller.properties;

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                ),
                              ),
                              child: SizedBox(
                                height: 250.h,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: props.length,
                                  onPageChanged: (index) {
                                    controller.currentPage.value = index;
                                  },
                                  itemBuilder: (context, index) {
                                    final property = props[index];
                                    final imageUrl =
                                        "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
                                    final location =
                                        "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                                    final propertyType = property.propertyType?.name ?? '';
                                    final subType =
                                        property.residential?.residentialPropertyType?.name ??
                                            property.commercial?.commercialPropertyType?.name ?? '';

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.PROPERTY_DETAILS,
                                              arguments: property.id,
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
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
                                                        'assets/backgrounds/default_placeholder.png',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                /// Gradient overlay
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
                                                /// Text Info
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
                                                /// Floating Animated Heart
                                                Positioned(
                                                  top: 16.h,
                                                  right: 16.w,
                                                  child: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.white.withOpacity(0.8),
                                                    size: 28.sp,
                                                  ).animate(
                                                    onPlay: (controller) => controller.repeat(reverse: true),
                                                  ).scale(
                                                    begin: const Offset(0.8, 0.8),
                                                    end: const Offset(1.1, 1.1),
                                                    duration: 800.ms,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // إضافة نص "Properties" فوق أول كارد فقط
                                        if (index == 0)
                                          Positioned(
                                            top: 0, // يمكنك تعديل الموضع حسب الحاجة
                                            left: 16.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15.r),
                                                  topRight: Radius.circular(15.r),
                                                ),
                                              ),
                                              child: Text(
                                                'Properties',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 25.h,
                                left: 10.w,
                                right: 45.w,
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Explore More Properties', // تم تغيير النص هنا
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            _buildQuickActions(),
                            20.verticalSpace,
                          ],
                        );
                      }),
                      20.verticalSpace,
                    ],
                  ),
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// Shimmer Loader
  Widget _buildShimmerList() {
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColors.primary,
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                20.verticalSpace,
                Container(width: 150.w, height: 16.h, color: Colors.white),
                10.verticalSpace,
                Container(width: 100.w, height: 12.h, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Obx(() {
      final hasProperties = controller.properties.isNotEmpty;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            if (hasProperties)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.PropertiesUnifiedView,
                      arguments: controller.properties.first.id,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    height: 135.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/backgrounds/background1.jpeg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: AppColors.background1.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            10.horizontalSpace,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.ADDPROPERTY);
                },
                child: Container(
                  height: 135.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Stack(
                      children: [
                        // صورة خلفية افتراضية
                        Image.asset(
                          'assets/backgrounds/background1.jpeg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Overlay شفاف
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: AppColors.background1.withOpacity(0.3),
                          ),
                        ),
                        // محتوى النص والأيقونة
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 30.sp,
                                color: Colors.white,
                              ),
                              10.verticalSpace,
                              Text(
                                'Add New Property',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
      );
    });
  }
}