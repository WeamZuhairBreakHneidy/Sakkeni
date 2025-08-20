// import 'package:get/get.dart';
// import '../controllers/properties_offplan_controller.dart';
// import '../controllers/properties_purchase_controller.dart';
// import '../controllers/properties_rent_controller.dart';
//
// class PropertiesBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => RentController());
//     Get.lazyPut(() => PurchaseController());
//     Get.lazyPut(() => OffPlanController());
//   }
// }
import 'package:get/get.dart';
import 'package:test1/app/modules/auth/controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/controllers/logout_controller.dart';
import '../controllers/delete-property.dart';
import '../controllers/properties_offplan_controller.dart';
import '../controllers/properties_purchase_controller.dart';
import '../controllers/properties_rent_controller.dart';

class PropertiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RentController>(() => RentController());
    Get.lazyPut<PurchaseController>(() => PurchaseController());
    Get.lazyPut<OffPlanController>(() => OffPlanController());
    Get.lazyPut<DeletePropertyController>(() => DeletePropertyController());
    Get.lazyPut<LogoutController>(() => LogoutController());

    final typeParam = Get.parameters['type'];

    switch (typeParam) {
      case 'rent':
        Get.lazyPut(() => RentController());
        break;
      case 'purchase':
        Get.lazyPut(() => PurchaseController());
        break;
      case 'offplan':
        Get.lazyPut(() => OffPlanController());
        break;
      default:
        Get.lazyPut(() => RentController());
    }
  }
}
