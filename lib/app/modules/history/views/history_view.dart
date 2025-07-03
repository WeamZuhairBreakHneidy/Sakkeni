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

class HistoryView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(HistoryTabController(), permanent: true);

  HistoryView({super.key}) {
    final controller = getControllerForCurrentRoute();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadNextPage();
      }
    });
  }

  late final dynamic controller = getControllerForCurrentRoute();

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
                final props = controller.properties;
                final isLoading = controller.isLoading.value;

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
                  controller: scrollController,
                  itemCount: props.length + 1,
                  itemBuilder: (context, index) {
                    if (index < props.length) {
                      final property = props[index]; // Datum object

                      final imageUrl =
                          "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
                      final price =
                          property.rent?.price?.toStringAsFixed(0) ??
                          property.purchase?.price?.toStringAsFixed(0) ??
                          property.offplan?.overallPayment?.toStringAsFixed(
                            0,
                          ) ??
                          '0';

                      final location =
                          "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                      final lease =
                          property.rent?.leasePeriod?.toString() ?? '';
                      final propertyType = property.propertyType?.name ?? '';
                      final subType =
                          property.residential?.residentialPropertyType?.name ??
                          property.commercial?.commercialPropertyType?.name ??
                          '';

                      return PropertyCard(
                        imageUrl: imageUrl,
                        price: "\$$price",
                        leasePeriod: lease,
                        location: location,
                        propertyType: propertyType,
                        subType: subType,
                        onTap: () {
                          // فتح تفاصيل العقار
                        },
                      );
                    } else {
                      return Obx(
                        () =>
                            controller.isLoading.value
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
