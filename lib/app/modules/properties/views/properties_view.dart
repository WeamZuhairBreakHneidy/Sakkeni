import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/widgets/filter_sheet.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/properties_tab.dart';
import '../../../widgets/property_card.dart';
import '../controllers/properties_offplan_controller.dart';
import '../controllers/properties_purchase_controller.dart';
import '../controllers/properties_rent_controller.dart';
import '../controllers/properties_tab_controller.dart';

class PropertiesUnifiedView extends StatelessWidget {
  final scrollController = ScrollController();
  final tabController = Get.put(PropertiesTabController(), permanent: true);

  PropertiesUnifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.updateTabFromType(Get.parameters['type']);
    });

    return Scaffold(
      backgroundColor: AppColors.background1,
      body: Column(
        children: [
          // Header with Logo and Search
          buildHeaderSection(context),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  TabSelector(
                    controller: tabController,
                    tabs: ['For Rent', 'For Sale', 'Off plan'],
                    onTabSelected: (index) {
                      final route = switch (index) {
                        0 => '${Routes.PropertiesUnifiedView}?type=rent',
                        1 => '${Routes.PropertiesUnifiedView}?type=purchase',
                        2 => '${Routes.PropertiesUnifiedView}?type=offplan',
                        _ => '${Routes.PropertiesUnifiedView}?type=rent',
                      };
                      Get.offNamed(route);
                      Future.delayed(Duration(milliseconds: 100), () {
                        final controller = switch (index) {
                          0 => Get.find<RentController>(),
                          1 => Get.find<PurchaseController>(),
                          2 => Get.find<OffPlanController>(),
                          _ => Get.find<RentController>(),
                        };
                        controller.fetchProperties();
                      });
                    },
                  ),

                  17.verticalSpace,
                  Expanded(
                    child: Obx(() {
                      final selected = tabController.selectedTab.value;

                      final controller = switch (selected) {
                        0 => Get.find<RentController>(),
                        1 => Get.find<PurchaseController>(),
                        2 => Get.find<OffPlanController>(),
                        _ => Get.find<RentController>(),
                      };

                      final props = controller.properties;
                      final isLoading = controller.isLoading.value;

                      if (props.isEmpty && isLoading) {
                        return Center(
                          child: SizedBox(
                            height: 75,
                            width: 75,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballZigZagDeflect,
                              colors: [AppColors.primary],
                            ),
                          ),
                        );
                      }

                      if (props.isEmpty && !isLoading) {
                        return const Center(
                          child: Text("No properties found."),
                        );
                      }

                      return GridView.builder(
                        controller: scrollController,
                        itemCount: props.length + 1,
                        padding:  EdgeInsets.only(bottom: 16.h),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) {
                          if (index < props.length) {
                            final property = props[index]; // Datum object

                            final imageUrl =
                                "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
                            final price =
                                property.rent?.price?.toStringAsFixed(0) ??
                                property.purchase?.price?.toStringAsFixed(0) ??
                                property.offplan?.overallPayment
                                    ?.toStringAsFixed(0) ??
                                '0';

                            final location =
                                "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                            final lease =
                                property.rent?.leasePeriod?.toString() ?? '';
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget buildHeaderSection(BuildContext context) {
    return Container(
      color: AppColors.background1,
      padding: EdgeInsets.only(
        top: 61.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 110.76.w,
              height: 90.h,
              child: Image.asset('assets/Logo.png'),
            ),
          ),
          Container(
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text("Search", style: TextStyle(color: Colors.grey)),
                ),
                IconButton(
                  icon: Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (_) {
                        return Stack(
                          children: [
                            Positioned(
                              bottom: 80.h,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 560.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.r),
                                  ),
                                ),
                                child: FilterSheet(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Icon(Icons.add_circle_outline, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
