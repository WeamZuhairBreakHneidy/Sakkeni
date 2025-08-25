import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:iconsax/iconsax.dart'; // تأكد من استيراد هذه المكتبة
import '../../../core/theme/colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/add_service.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/service_card.dart';
import '../controllers/add_service_controller.dart';
import '../controllers/my_services_controller.dart';
import '../controllers/remove_service_controller.dart';

class MyServicesView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final MyServicesController controller = Get.put(MyServicesController());
  AddServiceController add =Get.put(AddServiceController());

  MyServicesView({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        // يمكن هنا تضيف تحميل المزيد إذا كنت تدعم Pagination
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: EdgeInsets.only(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              bottom: 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Text(
                        "My Services",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "View Request",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.request_quote_outlined),
                      onPressed: () {
                        Get.toNamed(Routes.PROVIDER_QUOTES);
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.dialog(AddServiceDialog(), barrierDismissible: false);
                      },
                      icon: const Icon(Iconsax.add, size: 18, color: Colors.white),
                      label: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r), // زر دائري أكثر
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        elevation: 3,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),

          // Main Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Obx(() {
                final services = controller.myServices;
                final isLoading = controller.isLoading.value;

                // Loading
                if (services.isEmpty && isLoading) {
                  return Center(
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: [AppColors.primary],
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }

                // Empty
                if (services.isEmpty && !isLoading) {
                  return const Center(child: Text("No services found."));
                }

                // Services List
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchMyServices();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final item = services[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: ServiceCard(
                          serviceName: item.service?.name ?? "N/A",
                          description: item.description ?? "",
                          availabilityStatus:
                          item.availabilityStatus?.name ?? "",
                          categoryName: item.service?.serviceCategory?.name ??
                              "N/A",
                          onTap: () {
                            Get.toNamed(
                              Routes.SERVICE_PROVIDER_GALLERY,
                              arguments: item.service?.id,
                            );
                          },
                          onDismissed: () async {
                            controller.myServices.refresh();
                            Get.defaultDialog(
                              title: "Confirm Delete",
                              middleText:
                              "Do you really want to delete this service?",
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              cancelTextColor: AppColors.primary,
                              confirmTextColor: AppColors.primary,
                              onConfirm: () async {
                                Get.back();
                                final removeController = Get.put(RemoveServiceController());
                                final success = await removeController.removeService(item.id!);

                                if (success) {
                                  controller.myServices.removeAt(index);
                                  controller.myServices.refresh();
                                } else {
                                  Get.snackbar(
                                      "Error", "Failed to remove service");
                                }
                              },
                              onCancel: () {
                                controller.myServices.refresh();
                              },
                            );
                          },
                          onEdit: () {
                            Get.toNamed(
                              Routes.EDIT_SERVICE,
                              arguments: {
                                "serviceId": item.serviceId,
                                "description": item.description,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),

    );
  }
}