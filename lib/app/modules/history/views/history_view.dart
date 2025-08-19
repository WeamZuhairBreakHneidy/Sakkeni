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
import '../../properties/controllers/delete-property.dart';
import '../controllers/history_rent_controller.dart';
import '../controllers/history_purchase_controller.dart';
import '../controllers/history_offplan_controller.dart';
import '../../../data/models/properties-model.dart'; // Ensure Datum is imported if it's not already

class HistoryView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(HistoryTabController(), permanent: true);
  late final dynamic _controller;
  final deleteController = Get.put(DeletePropertyController());

  HistoryView({super.key}) {
    _controller =
        getControllerForCurrentRoute(); // Initialized in the constructor
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        _controller.loadNextPage();
      }
    });
  }

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
      body: Column(
        children: [
          // Header
          Container(
            color: Theme.of(context).colorScheme.background,
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
                color: Theme.of(context).colorScheme.background,
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
                return RefreshIndicator(
                onRefresh: () async {
                  _controller.currentPage.value = 1;
                  _controller.hasMoreData.value = true;
                  _controller.properties.clear();
                  await _controller.fetchProperties(page: 1, isLoadMore: false);
                },
                child: ListView.builder(
                itemCount: props.length + (hasMoreData ? 1 : 0),
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                      if (index < props.length) {
                        final Datum? property = props[index];

                        if (property == null) {
                          print(
                            'Warning: Found a null property object at index $index. Skipping.',
                          );
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
                            property.rent?.price.toStringAsFixed(0) ??
                            property.purchase?.price.toStringAsFixed(0) ??
                            property.offplan?.overallPayment.toStringAsFixed(
                              0,
                            ) ??
                            '0';

                        final location =
                            "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                        final lease =
                            property.rent?.leasePeriod.toString() ?? '';
                        final propertyType = property.propertyType?.name ?? '';
                        final subType =
                            property
                                .residential
                                ?.residentialPropertyType
                                ?.name ??
                            property.commercial?.commercialPropertyType?.name ??
                            '';

                        return SizedBox(
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
                            onDelete: () {
                              Get.defaultDialog(
                                title: "Confirm Deletion",
                                middleText:
                                    "Are you sure you want to delete this property?",
                                onConfirm: () {
                                  deleteController.deleteProperty(property.id);
                                  Get.back(); // Close the dialog
                                },
                                onCancel: () {},
                                textConfirm: "Delete",
                                textCancel: "Cancel",
                                confirmTextColor: AppColors.white,
                                cancelTextColor: AppColors.primary,
                                buttonColor: AppColors.primary,
                              );
                            },
                          ),
                        );
                      } else {
                        return Obx(
                          () =>
                              _controller.isLoading.value &&
                                      _controller.hasMoreData.value
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
                  ),
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
