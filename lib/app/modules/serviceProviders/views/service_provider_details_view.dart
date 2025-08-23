import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
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
            // Upper half image
            SizedBox(
              height: 0.5.sh,
              width: 1.sw,
              child: details.profilePicturePath != null
                  ? Image.network(details.profilePicturePath!, fit: BoxFit.cover)
                  : Image.asset("assets/backgrounds/default.png", fit: BoxFit.cover),
            ),

            // DraggableScrollableSheet for details
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




                        // Name
                        Center(
                          child: Text(
                            "${details.firstName} ${details.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: 6.h),


                        if (details.rate != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 22.sp),
                              SizedBox(width: 6.w),
                              Text(
                                details.rate!.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          )
                        else
                          const Text("No rating yet",
                              style: TextStyle(color: Colors.grey)),


                        SizedBox(height: 6.h),



                        // Address row only
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.location_on, color: Colors.redAccent),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                details.address,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                        Text(details.description,
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 16.h),

                        // Services list
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
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Service Name
                                    Text(
                                      s.serviceName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),


                                    // Description
                                    if (s.description != null && s.description!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: Text(
                                          s.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.gray1),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),

                                    SizedBox(height: 12.h),

                                    // Buttons: Request Service & View Gallery
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              // Request service logic
                                            },
                                            icon: const Icon(Icons.add_task, color: AppColors.surface),
                                            label: Text(
                                              "Request",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(color: AppColors.surface),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              // Open gallery logic
                                              Get.toNamed(
                                                Routes.SERVICE_PROVIDER_GALLERY,
                                                arguments: s.id, // service_provider_service_id
                                              );
                                            },
                                            icon: const Icon(Icons.photo_library, color: AppColors.surface),
                                            label: Text(
                                              "Gallery",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(color: AppColors.surface),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 24.h),
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
                backgroundColor: AppColors.surface.withOpacity(0.7),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
