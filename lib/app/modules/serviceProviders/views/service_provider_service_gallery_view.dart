import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/service_provider_service_gallery_controller.dart';
import '../../../core/theme/colors.dart';

class ServiceProviderGalleryView extends GetView<ServiceProviderServiceGalleryController> {
  const ServiceProviderGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Main gallery content
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.gallery.isEmpty) {
                return const Center(
                  child: Text(
                    "No images found",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(14.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 0.9,
                ),
                itemCount: controller.gallery.length,
                itemBuilder: (context, index) {
                  final image = controller.gallery[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => FullScreenImageView(
                        images: controller.gallery.map((e) => e.imageUrl).toList(),
                        initialIndex: index,
                      ));
                    },
                    child: Hero(
                      tag: image.imageUrl,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Main Image
                            Image.network(
                              image.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2)),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image,
                                    size: 40, color: Colors.black26),
                              ),
                            ),

                            // Overlay for effect
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 60.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),


          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const FullScreenImageView({super.key, required this.images, required this.initialIndex});

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final imageUrl = widget.images[index];
              return Center(
                child: Hero(
                  tag: imageUrl,
                  child: InteractiveViewer(
                    minScale: 0.7,
                    maxScale: 4.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                          size: 60, color: Colors.white30),
                    ),
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: 40.h,
            right: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Image index indicator
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.images.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
