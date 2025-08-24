import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/services/validator_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/input_text_form_field.dart';
import '../../../widgets/responsive_buttun.dart';
import '../controllers/service_provider_details_controller.dart';
import '../models/service_provider.dart';
import '../../../core/theme/colors.dart';


class ServiceProviderDetailsView extends GetView<ServiceProviderDetailsController> {
  const ServiceProviderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Get.arguments as ServiceProvider;
    final serviceProviderId = provider.serviceProviderId;

    // Fetch details
    controller.fetchProviderDetails(serviceProviderId);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.providerDetails.value;
        if (details == null) {
          return const Center(child: Text("No details found"));
        }

        return Stack(
          children: [
            // Top image
            SizedBox(
              height: 0.5.sh,
              width: 1.sw,
              child: details.profilePicturePath != null
                  ? Image.network(details.profilePicturePath!, fit: BoxFit.cover)
                  : Image.asset("assets/backgrounds/default.png", fit: BoxFit.cover),
            ),

            // Details bottom sheet
            DraggableScrollableSheet(
              initialChildSize: 0.50,
              minChildSize: 0.50,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Provider name
                        Center(
                          child: Text(
                            "${details.firstName} ${details.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Rating
                        if (details.rate != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 22.sp),
                              SizedBox(width: 6.w),
                              Text(
                                details.rate!.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        else
                          const Text("No rating yet",
                              style: TextStyle(color: Colors.grey)),

                        SizedBox(height: 12.h),

                        // Address
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.redAccent),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(details.address, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // About
                        Text("About",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: AppColors.primary)),
                        SizedBox(height: 8.h),
                        Text(details.description),
                        SizedBox(height: 16.h),

                        // Services
                        Text("Services",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: AppColors.primary)),
                        SizedBox(height: 8.h),

                        Column(
                          children: details.services.map((s) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r)),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.serviceName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(fontWeight: FontWeight.bold)),

                                    if (s.description != null && s.description!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(s.description!),
                                      ),

                                    SizedBox(height: 12.h),

                                    // Buttons row
                                    Row(
                                      children: [
                                        // Request button
                                        Expanded(
                                          child: Obx(() => ResponsiveButton(
                                            clickable: !controller.isRequesting.value,
                                            onPressed: () {
                                              final descController = TextEditingController();
                                              Get.bottomSheet(

                                                Padding(
                                                  padding: EdgeInsets.all(20.w),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Request Service",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headlineSmall
                                                              ?.copyWith(
                                                              color: AppColors.primary,
                                                              fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 16.h),
                                                      TextField(
                                                        controller: descController,
                                                        maxLines: 4,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                        decoration: InputDecoration(
                                                          hintText: "Enter job description...",
                                                          hintStyle: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(color: AppColors.gray1),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12.r)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12.r),
                                                              borderSide: BorderSide(
                                                                  color: AppColors.primary, width: 2.w)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12.r),
                                                              borderSide:
                                                              BorderSide(color: AppColors.primary)),
                                                          filled: true,
                                                          fillColor: AppColors.surface,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20.h),

                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: ResponsiveButton(

                                                              clickable: true,
                                                              onPressed: () => Get.back(),

                                                              child: Text("Cancel",
                                                                  style: TextStyle(
                                                                      color: AppColors.primary)),
                                                            ),
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Expanded(
                                                            child: ResponsiveButton(
                                                              clickable: !controller.isRequesting.value,
                                                              onPressed: () {
                                                                final description =
                                                                descController.text.trim();
                                                                if (description.isEmpty) {
                                                                  Get.snackbar("Error",
                                                                      "Please enter a description");
                                                                  return;
                                                                }

                                                                Get.back();
                                                                Get.defaultDialog(
                                                                  title: "Confirm Request",
                                                                  middleText:
                                                                  "Are you sure you want to submit this request?",
                                                                  textCancel: "No",
                                                                  textConfirm: "Yes, Submit",
                                                                  confirmTextColor: Colors.white,
                                                                  cancelTextColor: AppColors.primary,
                                                                  buttonColor: AppColors.primary,
                                                                  radius: 12.r,
                                                                  onConfirm: () async {
                                                                    Get.back();
                                                                    await controller.requestService(
                                                                      serviceProviderId:
                                                                      serviceProviderId,
                                                                      serviceId: s.id,
                                                                      jobDescription: description,
                                                                    );


                                                                  },
                                                                );
                                                              },

                                                              buttonStyle: ElevatedButton.styleFrom(
                                                                backgroundColor: AppColors.primary,
                                                              ),
                                                              child: controller.isRequesting.value
                                                                  ? const SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child: CircularProgressIndicator(
                                                                  color: Colors.white,
                                                                  strokeWidth: 2,
                                                                ),
                                                              )
                                                                  : const Text("Submit",
                                                                  style: TextStyle(color: Colors.white)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                isScrollControlled: true,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20.r))),
                                              );
                                            },
                                            buttonStyle: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.add_task, color: Colors.white),
                                                SizedBox(width: 6),
                                                Text("Request", style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          )),
                                        ),
                                        SizedBox(width: 12.w),
                                        // Gallery button
                                        Expanded(
                                          child: ResponsiveButton(
                                            clickable: true,
                                            onPressed: () {
                                              Get.toNamed(Routes.SERVICE_PROVIDER_GALLERY, arguments: s.id);
                                            },
                                            buttonStyle: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.photo_library, color: Colors.white),
                                                SizedBox(width: 6),
                                                Text("Gallery", style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Back button
            Positioned(
              top: 40.h,
              left: 16.w,
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar:  CustomBottomNavBar(),
    );
  }
}
