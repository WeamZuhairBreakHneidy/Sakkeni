import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/properties_offplan_controller.dart';
import '../controllers/properties_purchase_controller.dart';
import '../controllers/properties_rent_controller.dart';
import 'properties_grid_view.dart';

class FilteredPropertiesView extends StatelessWidget {
  final ScrollController scrollController;
  final RxList<Map<String, dynamic>> filteredData;

  const FilteredPropertiesView({
    super.key,
    required this.scrollController,
    required this.filteredData,
  });

  @override
  Widget build(BuildContext context) {
    final type = filteredData.first['type'] ?? 'rent';
    final controller = switch (type) {
      'rent' => Get.find<RentController>(),
      'purchase' => Get.find<PurchaseController>(),
      'offplan' => Get.find<OffPlanController>(),
      _ => Get.find<RentController>(),
    };
    final props = controller.properties;
    final isLoading = controller.isLoading.value;

    return PropertiesGridView(
      scrollController: scrollController,
      controller: controller,
      props: props,
      isLoading: isLoading,
    );
  }
}
