import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import '../controllers/service_providers_controller.dart';

class ServiceProvidersView extends GetView<ServiceProvidersController> {
  const ServiceProvidersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("${controller.serviceName} Providers")),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.providers.isEmpty) {
          return const Center(child: Text("No providers found"));
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.75, // adjust height/width ratio
          ),
          itemCount: controller.providers.length,
          itemBuilder: (context, index) {
            final provider = controller.providers[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                Get.toNamed(
                  Routes.PROVIDER_DETAILS,
                  arguments: provider,
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.only( bottom: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile photo
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: provider.profilePicturePath != null
                              ? Image.network(
                            provider.profilePicturePath!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            "assets/backgrounds/default.png",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Name
                      Text(
                        "${provider.firstName} ${provider.lastName}".trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4.h),

                      // Address
                      Text(
                        provider.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color:Theme.of(context).primaryColor ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
