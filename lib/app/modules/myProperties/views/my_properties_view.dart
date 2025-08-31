import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/modules/myProperties/controllers/my_properties_offplan_controller.dart';
import 'package:test1/app/modules/myProperties/controllers/my_properties_purchase_controller.dart';
import 'package:test1/app/modules/myProperties/controllers/my_properties_rent_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/properties_tab.dart';
import '../../../widgets/property_card.dart';
import '../../payment/controllers/payment_properties_controller.dart';
import '../../properties/controllers/delete-property.dart';

import '../controllers/my_properties_controller.dart'; // Import abstract controller
import '../controllers/my_properties_tab_controller.dart';

class MyPropertiesView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(MyPropertiesTabController(), permanent: true);
  late final MyPropertiesController _controller; // Use abstract controller type
  final deleteController = Get.put(DeletePropertyController());
  final PaymentPropertiesController paymentPropertiesController = Get.put(
    PaymentPropertiesController(),
  );

  MyPropertiesView({super.key}) {
    print('MyPropertiesView: Route parameters: ${Get.parameters}'); // Debug log
    _controller = getControllerForCurrentRoute();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        _controller.loadNextPage();
      }
    });
  }

  MyPropertiesController getControllerForCurrentRoute() {
    final typeParam = Get.parameters['type'] ?? 'rent';
    print(
      'MyPropertiesView: Getting controller for type=$typeParam',
    ); // Debug log
    try {
      switch (typeParam) {
        case 'rent':
          return Get.find<MyPropertiesRentController>();
        case 'purchase':
          return Get.find<MyPropertiesCPurchaseController>();
        case 'offplan':
          return Get.find<MyPropertiesOffPlanController>();
        default:
          return Get.find<MyPropertiesRentController>();
      }
    } catch (e) {
      print('Error finding controller for type $typeParam: $e');
      // Fallback to rent controller
      return Get.find<MyPropertiesRentController>();
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
                      0 => '${Routes.MY_PROPERTIES}?type=rent',
                      1 => '${Routes.MY_PROPERTIES}?type=purchase',
                      2 => '${Routes.MY_PROPERTIES}?type=offplan',
                      _ => '${Routes.MY_PROPERTIES}?type=rent',
                    };
                    print('Navigating to: $route'); // Debug log
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
                    await _controller.fetchProperties(
                      page: 1,
                      isLoadMore: false,
                    );
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

                        // Determine status text and color
                        String? statusText;
                        Color? statusColor;
                        final status = property.availabilityStatus?.name;
                        switch (status) {
                          case "Pending":
                            statusText = "Pending";
                            statusColor = Colors.grey;
                            break;
                          case "Active":
                            statusText = "Active";
                            statusColor = Colors.green;
                            break;
                          case "InActive":
                            statusText = "Inactive";
                            statusColor = Colors.red;
                            break;
                          case "Rejected":
                            statusText = "Rejected";
                            statusColor = Colors.red;
                            break;
                          case "Sold":
                            statusText = "Sold";
                            statusColor = Colors.purple;
                            break;
                          case "Pending Payment":
                            statusText = "Pending Payment";
                            statusColor = Colors.orange;
                            break;
                          default:
                            statusText = null;
                            statusColor = null;
                        }

                        final bool showPayButton = status == "Pending Payment";

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: PropertyCard(
                            imageUrl: imageUrl,
                            price: "\$$price",
                            leasePeriod: lease,
                            location: location,
                            propertyType: propertyType,
                            subType: subType,
                            showPayButton: showPayButton,
                            onPayNow:
                                showPayButton
                                    ? () =>
                                        paymentPropertiesController.makePayment(
                                          propertyId: property.id.toString(),
                                        )
                                    : null,
                            onTap: () {
                              Get.toNamed(
                                Routes.PROPERTY_DETAILS,
                                arguments: property.id,
                              );
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
                            statusText: statusText,
                            statusColor: statusColor,
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
