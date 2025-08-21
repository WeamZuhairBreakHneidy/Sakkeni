import 'package:get/get.dart';
import '../controllers/my_properties_offplan_controller.dart';
import '../controllers/my_properties_purchase_controller.dart';
import '../controllers/my_properties_rent_controller.dart';


class MyPropertiesBinding extends Bindings {
  @override
  void dependencies() {
    final typeParam = Get.parameters['type'];

    switch (typeParam) {
      case 'rent':
        Get.lazyPut(() => MyPropertiesRentController());
        break;
      case 'purchase':
        Get.lazyPut(() => MyPropertiesOffPlanController());
        break;
      case 'offplan':
        Get.lazyPut(() => MyPropertiesOffPlanController());
        break;
      default:
        Get.lazyPut(() => MyPropertiesRentController());
    }
  }
}
