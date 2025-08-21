import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/service_provider_service_gallery_controller.dart';
import '../../../core/theme/colors.dart';

class ServiceProviderGalleryView extends GetView<ServiceProviderServiceGalleryController> {
  const ServiceProviderGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = 1.sw; // Using ScreenUtil for width

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.gallery.isEmpty) {
          return const Center(child: Text("No images found"));
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.gallery.length,
          itemBuilder: (context, index) {
            final image = controller.gallery[index];

            // Staggered height
            final randomHeight = screenWidth * (0.6 + Random().nextDouble() * 0.4);

            return GestureDetector(
              onTap: () {
                Get.to(() => FullScreenImageView(imageUrl: image.imageUrl));
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 50, end: 0),
                duration: Duration(milliseconds: 500 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: value == 0 ? 1 : 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        width: screenWidth,
                        height: randomHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          image.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder: (_, __, ___) => Image.asset(
                            "assets/backgrounds/services.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Get.back(),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) =>
                progress == null ? child : const Center(child: CircularProgressIndicator()),
                errorBuilder: (_, __, ___) =>
                    Image.asset("assets/backgrounds/services.png", fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
