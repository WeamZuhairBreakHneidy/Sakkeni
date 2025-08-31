import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/widgets/filter_sheet.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/upgrade-to-seller.dart';
import '../controllers/properties_tab_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import 'filtered_properties_view.dart';
import 'tabbed_properties_view.dart';
import '../controllers/search_controller.dart';

class PropertiesUnifiedView extends StatelessWidget {
  final scrollController = ScrollController();
  final tabController = Get.put(PropertiesTabController(), permanent: true);
  final searchController = Get.put(PropertiesSearchController());

  final box = GetStorage();

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
                if (searchController.isSearching.value) {
                  if (searchController.searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        "error_no_results_found".tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return FilteredPropertiesView(
                    scrollController: scrollController,
                    filteredData: searchController.searchResults,
                  );
                } else {
                  return TabbedPropertiesView(
                    scrollController: scrollController,
                    tabController: tabController,
                  );
                }
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// 🔹 Header Section with Search Bar
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

          /// Title + Search
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  10.horizontalSpace,
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Icon(Icons.holiday_village_outlined,
                  //             color: Theme.of(context).colorScheme.surface),
                  //         8.horizontalSpace,
                  //         Text(
                  //           "labels_properties_for_you".tr,
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleMedium!
                  //               .copyWith(
                  //             color: Theme.of(context).colorScheme.surface,
                  //             fontSize: 18.r,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     6.verticalSpace,
                  //     Container(
                  //       height: 3.h,
                  //       width: 120.w,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             AppColors.white,
                  //             AppColors.primary.withOpacity(0.4)
                  //           ],
                  //         ),
                  //         borderRadius: BorderRadius.circular(10.r),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Obx(
                        () => Container(
                      height: 45.h,
                      width: 280.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: searchController.searchTextController,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            searchController.searchProperties(value);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "hint_text_search".tr,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon:
                          const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: searchController.isSearching.value
                              ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: Colors.redAccent),
                            onPressed: () {
                              searchController.clearSearch();
                            },
                          )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Right side
              Row(
                children: [
                  /// Search Field
                  /// Filter
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
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
                                    color:
                                    Theme.of(context).colorScheme.background,
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

                  /// Add property button
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: AppColors.search,
                      size: 35.w,
                    ),
                    onPressed: () {
                      final isSeller = box.read('isSeller') ?? false;

                      if (isSeller) {
                        Get.toNamed(Routes.ADDPROPERTY);
                      } else {
                        showUpgradeToSellerDialog();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}