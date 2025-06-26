import 'package:get/get.dart';
import 'package:test1/app/modules/properties/controllers/properties_offplan_controller.dart';
import 'package:test1/app/modules/properties/controllers/properties_purchase_controller.dart';

import '../controllers/properties_rent_controller.dart';

class PropertiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentController>(
      () => RentController(),
    ); Get.lazyPut<PurchuseController>(
      () => PurchuseController(),
    );
    Get.lazyPut<OffPlanController>(
      () => OffPlanController(),
    );
  }
}
