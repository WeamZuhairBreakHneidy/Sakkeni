import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Get.locale?.languageCode == 'ar' ? AppDrawer() : null,
      endDrawer: Get.locale?.languageCode == 'en' ? AppDrawer() : null,
      body: Column(
        children: [
          buildHeaderSection(context),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
Widget buildHeaderSection(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 61.h,  bottom: 16.h),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder:
                  (context) => GestureDetector(
                onTap: () {
                  if (Get.locale?.languageCode == 'en') {
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
                    color: AppColors.search,
                    borderRadius:
                    Get.locale?.languageCode == 'en'
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


          ],
        ),
      ],
    ),
  );
}