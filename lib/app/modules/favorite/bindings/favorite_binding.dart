import 'package:get/get.dart';

import '../../auth/controllers/logout_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/favorite_offplan_controller.dart';
import '../controllers/favorite_purchase_controller.dart';
import '../controllers/favorite_rent_controller.dart';
class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    final typeParam = Get.parameters['type'];
    Get.lazyPut<LogoutController>(() => LogoutController());

    switch (typeParam) {
      case 'rent':
        Get.lazyPut(() => FavoriteRentController());
        break;
      case 'purchase':
        Get.lazyPut(() => FavoritePurchaseController());
        break;
      case 'offplan':
        Get.lazyPut(() => FavoriteOffPlanController());
        break;
      default:
        Get.lazyPut(() => FavoriteRentController());
    }
  }
}
