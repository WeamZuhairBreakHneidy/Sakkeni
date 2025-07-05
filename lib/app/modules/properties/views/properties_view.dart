import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/widgets/filter_sheet.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/properties_tab_controller.dart';
import 'filtered_properties_view.dart';
import 'tabbed_properties_view.dart';

class PropertiesUnifiedView extends StatelessWidget {
  final scrollController = ScrollController();
  final tabController = Get.put(PropertiesTabController(), permanent: true);
  final isFiltering = false.obs;
  final filteredData = <Map<String, dynamic>>[].obs;

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
          buildHeaderSection(context),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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

    // تحديث التاب المختار حسب النوع
    tabController.updateTabFromType(type);

    // تنقل إلى الواجهة مع البراميتر الصحيح
    final route = switch (type) {
      'rent' => '${Routes.PropertiesUnifiedView}?type=rent',
      'purchase' => '${Routes.PropertiesUnifiedView}?type=purchase',
      'offplan' => '${Routes.PropertiesUnifiedView}?type=offplan',
      _ => '${Routes.PropertiesUnifiedView}?type=rent',
    };
    Get.offNamed(route);
  }
}

Widget buildHeaderSection(BuildContext context) {
  return Container(
    color: AppColors.background1,
    padding: EdgeInsets.only(top: 61.h, left: 16.w, right: 16.w, bottom: 16.h),
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
        Row(
          children: [
            Expanded(
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print("Search tapped");
                        },
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
                                  child: Container(
                                    height: 650.h,
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
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(Icons.add_circle_rounded, color: AppColors.search),
              onPressed: () {
                Get.toNamed(Routes.ADDPROPERTY);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
