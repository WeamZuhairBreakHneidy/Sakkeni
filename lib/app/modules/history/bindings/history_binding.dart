import 'package:get/get.dart';
import '../controllers/history_offplan_controller.dart';
import '../controllers/history_purchase_controller.dart';
import '../controllers/history_rent_controller.dart';


class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    final typeParam = Get.parameters['type'];

    switch (typeParam) {
      case 'rent':
        Get.lazyPut(() => HistoryRentController());
        break;
      case 'purchase':
        Get.lazyPut(() => HistoryPurchaseController());
        break;
      case 'offplan':
        Get.lazyPut(() => HistoryOffPlanController());
        break;
      default:
        Get.lazyPut(() => HistoryRentController());
    }
  }
}
