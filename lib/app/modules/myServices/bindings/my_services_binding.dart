import 'package:get/get.dart';

import '../../serviceProviders/controllers/service_provider_service_gallery_controller.dart';
import '../controllers/my_services_controller.dart';

class MyServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyServicesController>(
      () => MyServicesController(),
    ); Get.lazyPut<ServiceProviderServiceGalleryController>(
      () => ServiceProviderServiceGalleryController(),
    );
  }
}
