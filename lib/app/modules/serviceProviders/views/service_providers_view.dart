import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/service_providers_controller.dart';

class ServiceProvidersView extends GetView<ServiceProvidersController> {
  const ServiceProvidersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          buildHeaderSection(context),

          /// Expanded body with rounded background
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.categories.isEmpty) {
                  return const Center(child: Text("No categories available"));
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 30.h),

                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category Label
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Container(
                            width: 95.w,
                            height: 28.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),

                            decoration: BoxDecoration(

                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor, fontSize: 14),
                              ),
                            ),
                          ),
                        ),

                        /// Services grid
                        if (category.services.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(

                              crossAxisCount: 2,
                              mainAxisSpacing: 12.h,
                              crossAxisSpacing: 12.w,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: category.services.length,
                            itemBuilder: (context, i) {
                              final service = category.services[i];
                              return _buildServiceCard(service.name);
                            },
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// Service card widget
  Widget _buildServiceCard(String name) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(

        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            /// Service image with error handling
            FadeInImage.assetNetwork(
              placeholder: "assets/placeholder_service.jpg",
              image:
              "https://picsum.photos/300/200?random=$name", // Demo image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/placeholder_service.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),

            /// Overlay with shield icon + text
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 51.h,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                

               margin: EdgeInsets.all(45),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.all(
                     Radius.circular(100.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),

                child: const Icon(Icons.shield_outlined,
                    size: 30, color: Colors.black),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// Header widget (unchanged except minor spacing fix)
Widget buildHeaderSection(BuildContext context) {
  return Container(
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
                        child: const Text(
                          "Search",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
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
                                    child: const Icon(Icons.abc_sharp),
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
          ],
        ),
      ],
    ),
  );
}
