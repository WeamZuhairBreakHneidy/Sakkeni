import 'package:get/get.dart';
import '../controllers/my_properties_offplan_controller.dart';
import '../controllers/my_properties_purchase_controller.dart';
import '../controllers/my_properties_rent_controller.dart';

class MyPropertiesBinding extends Bindings {
  @override
  void dependencies() {
    final typeParam = Get.parameters['type'] ?? 'rent'; // Fallback to 'rent' if null
    print('MyPropertiesBinding: Initializing controller for type=$typeParam'); // Debug log

    switch (typeParam) {
      case 'rent':
        Get.lazyPut<MyPropertiesRentController>(
              () => MyPropertiesRentController(),
          fenix: true, // Ensures controller is recreated if deleted
        );
        break;
      case 'purchase':
        Get.lazyPut<MyPropertiesCPurchaseController>(
              () => MyPropertiesCPurchaseController(),
          fenix: true,
        );
        break;
      case 'offplan':
        Get.lazyPut<MyPropertiesOffPlanController>(
              () => MyPropertiesOffPlanController(),
          fenix: true,
        );
        break;
      default:
        Get.lazyPut<MyPropertiesRentController>(
              () => MyPropertiesRentController(),
          fenix: true,
        );
    }
  }
}