import 'package:get/get.dart';

import '../controllers/service_provider_service_gallery_controller.dart';

class ServiceProviderServiceGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderServiceGalleryController>(
          () => ServiceProviderServiceGalleryController(),
    );
  }
}
