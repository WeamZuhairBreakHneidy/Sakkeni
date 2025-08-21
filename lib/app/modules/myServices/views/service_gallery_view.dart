import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../serviceProviders/controllers/service_provider_service_gallery_controller.dart';

class ServiceProviderServiceGalleryView
    extends GetView<ServiceProviderServiceGalleryController> {
  const ServiceProviderServiceGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Gallery"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.gallery.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد صور في المعرض",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عدد الأعمدة
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.gallery.length,
          itemBuilder: (context, index) {
            final item = controller.gallery[index];
            return GestureDetector(
              onTap: () {
                // هنا ممكن تفتح صورة fullscreen
                Get.dialog(
                  Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
