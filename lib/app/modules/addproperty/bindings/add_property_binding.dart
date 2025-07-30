import 'package:get/get.dart';
import 'package:test1/app/modules/addproperty/controllers/amenties_controller.dart';
import 'package:test1/app/modules/addproperty/controllers/property_type_controller.dart';
import 'package:test1/app/modules/addproperty/controllers/sell_type_conrtoller.dart';

import '../controllers/add_property_controller.dart';
import '../controllers/add_property_tabs_controller.dart';
import '../controllers/countries_controller.dart';

class AddPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddpropertyController>(() => AddpropertyController());
    Get.lazyPut<AddpropertyTabsController>(() => AddpropertyTabsController());
    Get.lazyPut<SellTypeController>(() => SellTypeController());
    Get.lazyPut<PropertyTypeController>(() => PropertyTypeController());
    Get.lazyPut<AmenitiesController>(() => AmenitiesController());
    Get.lazyPut<CountriesController>(() => CountriesController(), fenix: true);
  }
}
