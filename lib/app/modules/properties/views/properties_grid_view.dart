import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/property_card.dart';

class PropertiesGridView extends StatelessWidget {
  final dynamic controller;
  final List props;
  final bool isLoading;
  final ScrollController scrollController;

  const PropertiesGridView({
    super.key,
    required this.controller,
    required this.props,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (props.isEmpty && isLoading) {
      return Center(
        child: SizedBox(
          height: 75,
          width: 75,
          child: LoadingIndicator(
            indicatorType: Indicator.ballZigZagDeflect,
            colors: [AppColors.primary],
          ),
        ),
      );
    }

    if (props.isEmpty && !isLoading) {
      return Center(child: Text("No properties found."));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchProperties(force: true);
      },
      child: GridView.builder(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: props.length,
        padding: EdgeInsets.only(bottom: 16.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          final property = props[index];
          final imageUrl =
              "${ApiService().baseUrl}/${property.coverImage?.imagePath ?? ''}";
          final price =
              property.rent?.price?.toStringAsFixed(0) ??
              property.purchase?.price?.toStringAsFixed(0) ??
              property.offplan?.overallPayment?.toStringAsFixed(0) ??
              '0';
          final location =
              "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
          final lease = property.rent?.leasePeriod?.toString() ?? '';
          final propertyType = property.propertyType?.name ?? '';
          final subType =
              property.residential?.residentialPropertyType?.name ??
              property.commercial?.commercialPropertyType?.name ??
              '';

          return PropertyCard(
            imageUrl: imageUrl,
            price: "\$$price",
            leasePeriod: lease,
            location: location,
            propertyType: propertyType,
            subType: subType,
            onTap: () {
              print(property.id);
              print(property.id);
              print(property.id);
              print(property.id);

              Get.toNamed(Routes.PROPERTY_DETAILS, arguments: property.id);
            },
          );
        },
      ),
    );
  }
}
