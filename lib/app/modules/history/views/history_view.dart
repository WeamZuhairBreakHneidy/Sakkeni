import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/modules/history/controllers/history_tab_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/properties_tab.dart';
import '../../../widgets/property_card.dart';
import '../controllers/history_rent_controller.dart';
import '../controllers/history_purchase_controller.dart';
import '../controllers/history_offplan_controller.dart';
import '../../../data/models/properties-model.dart'; // Ensure Datum is imported if it's not already

class HistoryView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(HistoryTabController(), permanent: true);
  late final dynamic _controller; // Declared as late final

  HistoryView({super.key}) {
    _controller = getControllerForCurrentRoute(); // Initialized in the constructor
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        _controller.loadNextPage();
      }
    });
  }

  // Helper method to get the correct controller based on route parameters.
  dynamic getControllerForCurrentRoute() {
    final typeParam = Get.parameters['type'] ?? 'rent';
    switch (typeParam) {
      case 'rent':
        return Get.find<HistoryRentController>();
      case 'purchase':
        return Get.find<HistoryPurchaseController>();
      case 'offplan':
        return Get.find<HistoryOffPlanController>();
      default:
        return Get.find<HistoryRentController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.white,
            padding: EdgeInsets.only(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              bottom: 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Text(
                    "Account History",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                10.verticalSpace,
                Divider(height: 1.h, color: Colors.grey),
                20.verticalSpace,
                TabSelector(
                  controller: tabController,
                  tabs: ['For Rent', 'For Sale', 'Off plan'],
                  onTabSelected: (index) {
                    final route = switch (index) {
                      0 => '${Routes.VIEWHISTORY}?type=rent',
                      1 => '${Routes.VIEWHISTORY}?type=purchase',
                      2 => '${Routes.VIEWHISTORY}?type=offplan',
                      _ => '${Routes.VIEWHISTORY}?type=rent',
                    };
                    Get.offNamed(route);
                  },
                ),
              ],
            ),
          ),

          // Main Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                final props = _controller.properties;
                final isLoading = _controller.isLoading.value;
                final hasMoreData = _controller.hasMoreData.value;

                if (props.isEmpty && isLoading) {
                  return Center(
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [AppColors.primary],
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }
                if (props.isEmpty && !isLoading) {
                  return const Center(child: Text("No properties found."));
                }
                return ListView.builder(
                  itemCount: props.length + (hasMoreData ? 1 : 0),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index < props.length) {
                      final Datum? property = props[index];

                      if (property == null) {
                        print('Warning: Found a null property object at index $index. Skipping.');
                        return const SizedBox.shrink();
                      }

                      final String imageUrl;
                      String? imagePath = property.coverImage?.imagePath;
                      if (imagePath != null && imagePath.isNotEmpty) {
                        imageUrl = "${ApiService().baseUrl}/$imagePath";
                      } else {
                        imageUrl = 'https://via.placeholder.com/150';
                      }

                      final price =
                          property.rent?.price?.toStringAsFixed(0) ??
                              property.purchase?.price?.toStringAsFixed(0) ??
                              property.offplan?.overallPayment?.toStringAsFixed(0) ??
                              '0';

                      final location =
                          "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                      final lease = property.rent?.leasePeriod?.toString() ?? '';
                      final propertyType = property.propertyType?.name ?? '';
                      final subType =
                          property.residential?.residentialPropertyType?.name ??
                              property.commercial?.commercialPropertyType?.name ??
                              '';

                      // **هنا التعديل: نغلف PropertyCard بـ SizedBox لتعيين ارتفاع محدد**
                      return SizedBox(
                        height: 200.h, // يمكنك تعديل هذا الارتفاع ليناسب تصميم بطاقتك
                        child: PropertyCard(
                          imageUrl: imageUrl,
                          price: "\$$price",
                          leasePeriod: lease,
                          location: location,
                          propertyType: propertyType,
                          subType: subType,
                          onTap: () {
                            // Navigate to property details if needed
                          },
                        ),
                      );
                    } else {
                      return Obx(
                            () => _controller.isLoading.value && _controller.hasMoreData.value
                            ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox(),
                      );
                    }
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
}