import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/widgets/filter_sheet.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../controllers/properties_tab_controller.dart';
import '../../auth/controllers/auth_controller.dart'; // ✅ استدعاء AuthController
import 'filtered_properties_view.dart';
import 'tabbed_properties_view.dart';

class PropertiesUnifiedView extends StatelessWidget {
  final scrollController = ScrollController();
  final tabController = Get.put(PropertiesTabController(), permanent: true);
  final isFiltering = false.obs;
  final filteredData = <Map<String, dynamic>>[].obs;

  // ✅ نجيب AuthController
  final authController = Get.find<AuthController>();

  PropertiesUnifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.updateTabFromType(Get.parameters['type']);
    });

    return Scaffold(
      drawer: AppDrawer(),
      body: Column(
        children: [
          buildHeaderSection(context),

          /// Expanded body
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                return isFiltering.value
                    ? FilteredPropertiesView(
                  scrollController: scrollController,
                  filteredData: filteredData,
                )
                    : TabbedPropertiesView(
                  scrollController: scrollController,
                  tabController: tabController,
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void applyFilterAndNavigate(String type, List<Map<String, dynamic>> data) {
    isFiltering.value = true;
    filteredData.assignAll(data);

    tabController.updateTabFromType(type);

    final route = switch (type) {
      'rent' => '${Routes.PropertiesUnifiedView}?type=rent',
      'purchase' => '${Routes.PropertiesUnifiedView}?type=purchase',
      'offplan' => '${Routes.PropertiesUnifiedView}?type=offplan',
      _ => '${Routes.PropertiesUnifiedView}?type=rent',
    };
    Get.offNamed(route);
  }

  /// 🔹 Consistent Header Section
  Widget buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 61.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Logo
          Center(
            child: SizedBox(
              width: 110.76.w,
              height: 90.h,
              child: Image.asset('assets/Logo.png'),
            ),
          ),

          /// Row: Menu + Search + Filter + Add
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// Drawer Button
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.search,
                      borderRadius: Get.locale?.languageCode == 'en'
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

              8.horizontalSpace,

              /// Search Bar + Filter
              Expanded(
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => print("Search tapped"),
                          child: Text(
                            "Search",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
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
                                    top: 0,
                                    child: Container(
                                      height: 650.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
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
                    ],
                  ),
                ),
              ),

              /// Add property button
              IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: AppColors.search,
                  size: 35.w,
                ),
                onPressed: () {
                  final isSeller = authController.isSellerFromStorage;
                  print('Is Seller (from Storage): $isSeller');

                  if (isSeller) {
                    Get.toNamed(Routes.ADDPROPERTY);
                  } else {
                    showUpgradeToSellerDialog();
                  }
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
