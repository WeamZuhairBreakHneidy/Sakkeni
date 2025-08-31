import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test1/app/widgets/upgrade_to_service_provider.dart';

import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../controllers/best_service_providers_controller.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/colors.dart';

class HomeView extends GetView<RecommendedPropertiesController> {
  HomeView({super.key});

  final box = GetStorage();
  final FavoriteController favController = Get.put(FavoriteController());
  final BestServiceProvidersController providersController = Get.put(
    BestServiceProvidersController(),
  );

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(
      viewportFraction: 0.90,
    );
    final PageController providersPageController = PageController(
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 4), (timer) {
        if (providersPageController.hasClients) {
          final currentPage = providersPageController.page?.round() ?? 0;
          if (currentPage == providersController.providers.length - 1) {
            providersPageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            providersPageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });

    return Scaffold(
      endDrawer: AppDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeaderSection(context),
                20.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSectionTitle(
                          context,
                          "labels_properties_you_might_like".tr,
                          Icons.home_rounded,
                        ),
                        25.verticalSpace,
                        Obx(() {
                          if (controller.isLoading.value &&
                              controller.properties.isEmpty) {
                            return _buildShimmerList();
                          }
                          final props = controller.properties;
                          return Column(
                            children: [
                              SizedBox(
                                height: 300.h,
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
                                      child: _buildPropertyCard(
                                        imageUrl,
                                        location,
                                        propertyType,
                                        subType,
                                        index,
                                        property.id!,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              10.verticalSpace,
                              if (props.isNotEmpty)
                                SmoothPageIndicator(
                                  controller: pageController,
                                  count: props.length,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: AppColors.primary,
                                    dotHeight: 8,
                                    dotWidth: 8,
                                  ),
                                ),
                            ],
                          );
                        }),
                        30.verticalSpace,
                        _buildSectionTitle(
                          context,
                          "labels_start_your_property_journey".tr,
                          Icons.explore,
                        ),
                        25.verticalSpace,
                        buildQuickActions([
                          {
                            'imagePath': 'assets/backgrounds/properties.png',
                            'icon': Icons.list_alt_rounded,
                            'label': 'buttons_view_properties'.tr,
                            'onTap':
                                () => Get.toNamed(
                              Routes.PropertiesUnifiedView,
                              arguments: controller.properties.first.id,
                            ),
                          },
                          {
                            'imagePath': 'assets/backgrounds/add.png',
                            'icon': Icons.add_circle_outline,
                            'label': 'buttons_add_new_property'.tr,
                            'onTap': () {
                              final isSeller = box.read('isSeller') ?? false;
                              if (isSeller) {
                                Get.toNamed(Routes.ADDPROPERTY);
                              } else {
                                showUpgradeToSellerDialog();
                              }
                            },
                          },
                        ]),
                        30.verticalSpace,
                        _buildSectionTitle(
                          context,
                          "labels_top_service_providers".tr,
                          Icons.handshake_rounded,
                        ),
                        25.verticalSpace,
                        Obx(() {
                          if (providersController.isLoading.value &&
                              providersController.providers.isEmpty) {
                            return _buildShimmerList();
                          }
                          final providers = providersController.providers;
                          return Column(
                            children: [
                              SizedBox(
                                height: 150.h,
                                child: PageView.builder(
                                  controller: providersPageController,
                                  itemCount: providers.length,
                                  onPageChanged: (index) {
                                    providersController.currentPage.value =
                                        index;
                                  },
                                  itemBuilder: (context, index) {
                                    final provider = providers[index];
                                    final imageUrl =
                                        "${ApiService().baseUrl}/${provider.id ?? ''}";
                                    final serviceName =
                                        provider.firstServiceName;
                                    final serviceCategory =
                                        provider.firstServiceCategoryName;
                                    return GestureDetector(
                                      onTap: () {},
                                      child: _buildProviderCard(
                                        imageUrl,
                                        "$serviceName - $serviceCategory",
                                        index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    Get.toNamed(Routes.SERVICE_PROVIDERS);
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.sp,
                                  ),
                                  label: Text(
                                    "buttons_more_service_providers".tr,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              if (providers.isNotEmpty)
                                SmoothPageIndicator(
                                  controller: providersPageController,
                                  count: providers.length,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: AppColors.primary,
                                    dotHeight: 8,
                                    dotWidth: 8,
                                  ),
                                ),
                              30.verticalSpace,
                              _buildSectionTitle(
                                context,
                                "labels_step_into_services".tr,
                                Icons.medical_services_outlined,
                              ),
                              25.verticalSpace,
                              buildQuickActions([
                                {
                                  'imagePath': 'assets/backgrounds/services.png',
                                  'icon': Icons.list_alt_rounded,
                                  'label': 'buttons_view_services'.tr,
                                  'onTap':
                                      () => Get.offNamed(
                                    Routes.SERVICES,
                                    arguments:
                                    controller.properties.first.id,
                                  ),
                                },
                                {
                                  'imagePath': 'assets/backgrounds/addservice.png',
                                  'icon': Icons.add_circle_outline,
                                  'label': 'buttons_add_new_service'.tr,
                                  'onTap': () {
                                    final isServiceProvider =
                                        box.read('isServiceProvider') ?? false;
                                    if (isServiceProvider) {
                                      Get.toNamed(Routes.ADDPROPERTY);
                                    } else {
                                      showUpgradeToServiceProviderDialog();
                                    }
                                  },
                                },
                              ]),
                              10.verticalSpace,
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            8.horizontalSpace,
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        6.verticalSpace,
        Container(
          height: 3.h,
          width: 120.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.4)],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ],
    );
  }

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

  Widget _buildPropertyCard(
      String imageUrl,
      String location,
      String propertyType,
      String subType,
      int index,
      int propertyId,
      ) {
    return Stack(
      children: [
        Container(
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
                      'assets/backgrounds/default_placeholder.png',
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
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Obx(() {
                  final isLoading =
                      favController.loadingStatus[propertyId] ?? false;
                  final isFavorited = favController.isFavorite(propertyId);
                  return GestureDetector(
                    onTap:
                    isLoading
                        ? null
                        : () {
                      if (isFavorited) {
                        favController.removePropertyFromFavorite(
                          propertyId,
                        );
                      } else {
                        favController.addPropertyToFavorite(
                          propertyId,
                        );
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child:
                      isLoading
                          ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : Icon(
                        isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(isFavorited),
                        color:
                        isFavorited
                            ? Colors.red
                            : Colors.white.withOpacity(0.9),
                        size: 28.sp,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: (index * 100).ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
  }

  Widget buildQuickActions(List<Map<String, dynamic>> actions) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: List.generate(actions.length * 2 - 1, (index) {
          if (index.isOdd) {
            return 10.horizontalSpace;
          }
          final action = actions[index ~/ 2];
          return Expanded(
            child: _buildQuickActionCard(
              imagePath: action['imagePath'],
              icon: action['icon'],
              label: action['label'],
              onTap: action['onTap'],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickActionCard({
    IconData? icon,
    String? imagePath,
    required String label,
    required VoidCallback onTap,
  }) {return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 135.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Stack(
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(icon, size: 35.sp, color: Colors.white),
                  10.verticalSpace,
                  Text(
                    label,
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
  ).animate().slideY(begin: 0.2, duration: 500.ms).fadeIn();
  }

  Widget buildHeaderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "labels_welcome_to_sakkeni".tr,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              "labels_find_your_dream_home".tr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Builder(
          builder:
              (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Container(
              width: 40.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.search,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.menu_open_sharp,
                size: 22.sp,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(String imageUrl, String category, int index) {
    return Stack(
      children: [
        Container(
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
                      'assets/backgrounds/serviceprovider.png',
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
                      category,
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
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: (index * 100).ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
  }
}