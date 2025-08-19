import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/properties_tab.dart';
import '../controllers/properties_offplan_controller.dart';
import '../controllers/properties_purchase_controller.dart';
import '../controllers/properties_rent_controller.dart';
import '../controllers/properties_tab_controller.dart';
import 'properties_grid_view.dart';

class TabbedPropertiesView extends StatelessWidget {
  final ScrollController scrollController;
  final PropertiesTabController tabController;

  const TabbedPropertiesView({
    super.key,
    required this.scrollController,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabSelector(
          controller: tabController,
          tabs: ['For Rent', 'For Sale', 'Off plan'],
          onTabSelected: (index) {
            final route = switch (index) {
              0 => '${Routes.PropertiesUnifiedView}?type=rent',
              1 => '${Routes.PropertiesUnifiedView}?type=purchase',
              2 => '${Routes.PropertiesUnifiedView}?type=offplan',
              _ => '${Routes.PropertiesUnifiedView}?type=rent',
            };
            Get.offNamed(route);
            Future.delayed(Duration(milliseconds: 100), () {
              final controller = switch (index) {
                0 => Get.find<RentController>(),
                1 => Get.find<PurchaseController>(),
                2 => Get.find<OffPlanController>(),
                _ => Get.find<RentController>(),
              };
              controller.fetchProperties();
            });
          },
        ),
        17.verticalSpace,
        Expanded(
          child: Obx(() {
            final selected = tabController.selectedTab.value;
            final controller = switch (selected) {
              0 => Get.find<RentController>(),
              1 => Get.find<PurchaseController>(),
              2 => Get.find<OffPlanController>(),
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
          }),
        ),

      ],
    );
  }
}
