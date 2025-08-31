import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/property_card.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../controllers/delete-property.dart';

class PropertiesGridView extends StatelessWidget {
  final dynamic controller;
  final List props;
  final bool isLoading;
  final ScrollController scrollController;
  final FavoriteController favController = Get.put(FavoriteController());

  PropertiesGridView({
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
      return Center(child: Text("messages_no_properties_found".tr));
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
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.65,
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

          return Stack(
            children: [
              PropertyCard(
                imageUrl: imageUrl,
                price: "\$$price",
                leasePeriod: lease,
                location: location,
                propertyType: propertyType,
                subType: subType,
                onTap: () {
                  Get.toNamed(Routes.PROPERTY_DETAILS, arguments: property.id);
                },
              ),
              // Favorite button
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Obx(() {
                  final isLoading = favController.loadingStatus[property.id] ?? false;
                  final isFavorited =
                      favController.favoriteStatus[property.id] ?? false;

                  return GestureDetector(
                    onTap:
                    isLoading
                        ? null
                        : () {
                      if (isFavorited) {
                        favController.removePropertyFromFavorite(
                          property.id,
                        );
                      } else {
                        favController.addPropertyToFavorite(
                          property.id,
                        );
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child:
                      isLoading
                          ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : Icon(
                        isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(isFavorited),
                        color:
                        isFavorited
                            ? Colors.red
                            : Colors.white.withOpacity(0.9),
                        size: 28.sp,
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}