import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/modules/addproperty/controllers/add_property_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/properties_tab.dart';
import '../../properties/controllers/properties_tab_controller.dart';
import '../controllers/countries_controller.dart';

class ApartmentForRentView extends GetView<AddpropertyController> {
  ApartmentForRentView( {super.key});
  final PropertiesTabController tabController = Get.find<PropertiesTabController>();
  final countriesController = Get.find<CountriesController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 24.h,
                  bottom: 10.h,
                ),
                color: AppColors.white,
                child: Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF294741),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: Image.asset(
                            'assets/icons/property_icon.png',
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Add New Property",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: const Color(0xFF294741),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 50.w, right: 16.w),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),

              30.verticalSpace,

              // Dropdowns
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),

                      // Step Navigation
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Previous",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF294741),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                _buildCheckCircle(),
                                _buildStepLine(isFilled: true),
                                _buildStepCircle(isFilled: true),
                                _buildStepLine(isFilled: false),
                                _buildStepCircle(isFilled: false),
                              ],
                            ),

                            /// Next
                            GestureDetector(
                              onTap: () {
                                // Get.to(() => SummaryView());
                              },

                              child: Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                  )
              )]
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildCheckCircle() {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: const BoxDecoration(
        color: Color(0xFF294741),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.check, color: Colors.white, size: 14),
      ),
    );
  }

  Widget _buildStepCircle({required bool isFilled}) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFF294741), width: 2),
        shape: BoxShape.circle,
      ),
      child:
          isFilled
              ? Center(
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF294741),
                    shape: BoxShape.circle,
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildStepLine({required bool isFilled}) {
    return Container(
      width: 20.w,
      height: 2.h,
      color: isFilled ? const Color(0xFF294741) : Colors.grey.shade300,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}
