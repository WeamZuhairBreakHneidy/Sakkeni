import 'package:get/get.dart';

import '../controllers/add_property_controller.dart';
import '../controllers/add_property_tabs_controller.dart';
import '../controllers/countries_controller.dart';

class AddpropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddpropertyController>(() => AddpropertyController());
    Get.lazyPut<AddpropertyTabsController>(() => AddpropertyTabsController());
    //
    Get.lazyPut<CountriesController>(() => CountriesController(), fenix: true);
  }
}
