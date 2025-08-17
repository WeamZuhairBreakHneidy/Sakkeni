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
      viewportFraction: 0.85,
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
      drawer:  AppDrawer(),

      body: ListView(
        children: [
          buildHeaderSection(context),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [




                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 35.h,
                        ),
                        child: Container(
                          // width: double.infinity,
                          padding: EdgeInsets.only(right: 15.w),
                          decoration: BoxDecoration(
                              color: AppColors.search,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Recommended Properties',
                            style: Theme.of(context).textTheme.headlineSmall,

                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),

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
                                // color: Theme.of(context).scaffoldBackgroundColor, // This is the 'white screen'
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                ),
                              ),
                              child: SizedBox(
                                height: 300.h,
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: props.length,
                                  onPageChanged: (index) {
                                    controller.currentPage.value =
                                        index; // جديد
                                  },
                                  itemBuilder: (context, index) {
                                    final property = props[index];
                                    final imageUrl =
                                        "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
                                    final location =
                                        "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                                    final propertyType =
                                        property.propertyType?.name ?? '';
                                    final subType =
                                        property
                                            .residential
                                            ?.residentialPropertyType
                                            ?.name ??
                                            property
                                                .commercial
                                                ?.commercialPropertyType
                                                ?.name ??
                                            '';

                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.PROPERTY_DETAILS,
                                          arguments: property.id,
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                20.r,
                                              ),
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
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    20.r,
                                                  ),
                                                  child: Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                        ) {
                                                      return Image.asset(
                                                        'assets/backgrounds/default_placeholder.png',
                                                        fit: BoxFit.cover,
                                                        width:
                                                        double.infinity,
                                                        height:
                                                        double.infinity,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                /// Gradient overlay
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      20.r,
                                                    ),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(
                                                          0.6,
                                                        ),
                                                        Colors.transparent,
                                                      ],
                                                      begin:
                                                      Alignment
                                                          .bottomCenter,
                                                      end:
                                                      Alignment
                                                          .topCenter,
                                                    ),
                                                  ),
                                                ),

                                                /// Text Info
                                                Positioned(
                                                  bottom: 16.h,
                                                  left: 12.w,
                                                  right: 12.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        location,
                                                        style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "$propertyType • $subType",
                                                        style: TextStyle(
                                                          color:
                                                          Colors
                                                              .white70,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                /// Floating Animated Heart
                                                /// Floating Animated Heart
                                                Positioned(
                                                  top: 16.h,
                                                  right: 16.w,
                                                  child: Icon(
                                                    Icons
                                                        .favorite_border,
                                                    color: Colors.white
                                                        .withOpacity(
                                                      0.8,
                                                    ),
                                                    size: 28.sp,
                                                  )
                                                      .animate(
                                                    onPlay:
                                                        (
                                                        controller,
                                                        ) => controller
                                                        .repeat(
                                                      reverse:
                                                      true,
                                                    ),
                                                  )
                                                      .scale(
                                                    begin: const Offset(
                                                      0.8,
                                                      0.8,
                                                    ),
                                                    end: const Offset(
                                                      1.1,
                                                      1.1,
                                                    ),
                                                    duration: 800.ms,
                                                    curve:
                                                    Curves
                                                        .easeInOut,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                          .animate()
                                          .fadeIn(
                                        duration: 500.ms,
                                        delay: (index * 100).ms,
                                      )
                                          .scale(
                                        begin: const Offset(0.95, 0.95),
                                        curve: Curves.easeOut,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            50.verticalSpace,
                            _buildQuickActions(), // <-- The new method call
                            20.verticalSpace,
                          ],
                        );
                      }),
                      20.verticalSpace,
                    ],
                  )

                ],
              ),
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
        itemBuilder:
            (_, __) => Container(
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

  Widget buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 61.h, bottom: 16.h),
      child: Column(

        children: [
          Center(
            child: SizedBox(
              width: 110.76.w,
              height: 90.h,
              child: Image.asset('assets/Logo.png'),
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(
                builder:
                    (context) => GestureDetector(
                  onTap: () {

                      Scaffold.of(context).openDrawer();

                  },
                  child: Container(
                    width: 35.w,
                    height: 35.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.search,
                      borderRadius:
                      Get.locale?.languageCode == 'en'
                          ? BorderRadius.horizontal(
                        right: Radius.circular(10.r),
                      )
                          : BorderRadius.horizontal(
                        left: Radius.circular(10.r),
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
            ],
          ),

        ],
      ),
    );
  }
}
