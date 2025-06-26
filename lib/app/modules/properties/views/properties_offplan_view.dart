import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/modules/properties/controllers/properties_offplan_controller.dart';

import '../../../core/theme/colors.dart';
import '../../../widgets/CustomBottomNavBar.dart';
import '../../../widgets/properties_tab.dart';
import '../../../widgets/property_card.dart';
import '../controllers/properties_tab_controller.dart';

class PropertiesOffplanView extends StatelessWidget {
  final controller = Get.put(OffPlanController());
  final ScrollController scrollController = ScrollController();
  final tabController = Get.put(TabControllerX(), permanent: true);

  PropertiesOffplanView({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadNextPage();
      }
    });
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

          // Main content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  buildHeaderTabs(),
                  17.verticalSpace,
                  Expanded(
                    child: Obx(() {
                      final props = controller.properties;
                      final isLoading = controller.isLoading.value;

                      if (props.isEmpty && isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (props.isEmpty && !isLoading) {
                        return const Center(child: Text("No properties found."));
                      }

                      return GridView.builder(
                        controller: scrollController,
                        itemCount: props.length + 1,
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          if (index < props.length) {
                            final property = props[index];
                            return PropertyCard(property: property);
                          } else {
                            return Obx(() => controller.isLoading.value
                                ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                                : const SizedBox());
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

