import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
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

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.providers.length,
          itemBuilder: (context, index) {
            final provider = controller.providers[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 3,
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                onTap: () {
                  // Navigate to provider details page
                  Get.toNamed(
                    Routes.PROVIDER_DETAILS,
                    arguments: provider, // pass full provider object
                  );

                },
                contentPadding: EdgeInsets.all(12.w),
                leading: CircleAvatar(
                  radius: 28.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: provider.profilePicturePath != null
                      ? NetworkImage(provider.profilePicturePath!)
                      : const AssetImage("assets/backgrounds/default.png")
                  as ImageProvider,
                ),
                title: Text(
                  "${provider.firstName} ${provider.lastName}".trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  provider.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );

          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
