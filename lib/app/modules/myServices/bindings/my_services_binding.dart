import 'package:get/get.dart';

import '../../payment/controllers/sabscruption_controller.dart';
import '../../serviceProviders/controllers/service_provider_service_gallery_controller.dart';
import '../../services/controllers/services_controller.dart';
import '../controllers/add_service_controller.dart';
import '../controllers/my_services_controller.dart';

class MyServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyServicesController>(
      () => MyServicesController(),
    ); Get.lazyPut<ServiceProviderServiceGalleryController>(
      () => ServiceProviderServiceGalleryController(),
    );
    Get.lazyPut<ServiceProviderServiceGalleryController>(
          () => ServiceProviderServiceGalleryController(),
    ); Get.lazyPut<AddServiceController>(
          () => AddServiceController(),
    ); Get.lazyPut<ServicesController>(
          () => ServicesController(),fenix: true
    );;
    Get.lazyPut<SabscruptionController>(
          () => SabscruptionController(),fenix: true
    );
  }
}
