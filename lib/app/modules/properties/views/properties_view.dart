import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/properties_tab.dart';
import '../../../widgets/property_card.dart';
import '../controllers/properties_offplan_controller.dart';
import '../controllers/properties_purchase_controller.dart';
import '../controllers/properties_rent_controller.dart';
import '../controllers/properties_tab_controller.dart';

class PropertiesUnifiedView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(PropertiesTabController(), permanent: true);

  PropertiesUnifiedView({super.key}) {
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
    final typeParam = Get.parameters['type'] ?? 'rent'; // fallback

    switch (typeParam) {
      case 'rent':
        return Get.find<RentController>();
      case 'purchase':
        return Get.find<PurchaseController>();
      case 'offplan':
        return Get.find<OffPlanController>();
      default:
        return Get.find<RentController>();
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
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Icon(Icons.tune, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Icon(Icons.add_circle_outline, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                    bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),

                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  buildHeaderTabs(
                    tabController: tabController,
                    onTabSelected: (index) {
                      switch (index) {
                        case 0:
                          Get.offNamed('${Routes.PropertiesUnifiedView}?type=rent');
                          break;
                        case 1:
                          Get.offNamed('${Routes.PropertiesUnifiedView}?type=purchase');
                          break;
                        case 2:
                          Get.offNamed('${Routes.PropertiesUnifiedView}?type=offplan');
                          break;
                      }
                    },
                  ),                  17.verticalSpace,
                  Expanded(
                    child: Obx(() {
                      final props = controller.properties;
                      final isLoading = controller.isLoading.value;

                      if (props.isEmpty && isLoading) {
                        return Center(
                          child: SizedBox(
                            width: 75,
                            height: 75,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballZigZagDeflect,
                              colors: [AppColors.primary],
                              strokeWidth: 1,
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
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) {
                          if (index < props.length) {
                            return PropertyCard(property: props[index]);
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
}
