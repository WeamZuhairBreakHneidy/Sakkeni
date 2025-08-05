import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'recomended_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Get.locale?.languageCode == 'ar' ? AppDrawer() : null,
      endDrawer: Get.locale?.languageCode == 'en' ? AppDrawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header with logo and divider
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 110.76.w,
                          height: 90.h,
                          margin: EdgeInsets.only(top: 61.h),
                          child: Image.asset('assets/Logo.png'),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                        indent: 30,
                        endIndent: 30,
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
                // This is the white container section
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.all(Radius.circular(30.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Add content here
                ),
                // **هنا تم إضافة RecomendedProperties**
                20.verticalSpace,
                const RecommendedProperties(),
                // Other content below the white container
                // ...
              ],
            ),
          ),
          // Your button for the drawer
          Positioned(
            top: 100.h,
            right: Get.locale?.languageCode == 'en' ? 0.w : null,
            left: Get.locale?.languageCode == 'ar' ? 0.w : null,
            child: Builder(
              builder:
                  (context) => GestureDetector(
                    onTap: () {
                      if (Get.locale?.languageCode == 'ar') {
                        Scaffold.of(context).openDrawer();
                      } else {
                        Scaffold.of(context).openEndDrawer();
                      }
                    },
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius:
                            Get.locale?.languageCode == 'en'
                                ? BorderRadius.horizontal(
                                  left: Radius.circular(10.r),
                                )
                                : BorderRadius.horizontal(
                              right: Radius.circular(10.r),
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
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
