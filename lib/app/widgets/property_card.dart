import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../core/theme/themes.dart';
import '../data/models/properties-model.dart';
import '../data/services/api_service.dart';
import '../modules/property/views/property_view.dart';

class PropertyCard extends StatelessWidget {
  final Datum property;

  const PropertyCard({super.key, required this.property});
  // final SavedPropertiesController savedController = Get.find();

  num? getPropertyPrice(Datum property) {
    if (property.rent?.price != null) {
      return property.rent!.price;
    } else if (property.purchase?.price != null) {
      return property.purchase!.price;
    } else if (property.offplan?.overallPayment != null) {
      return property.offplan!.overallPayment;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(SavedPropertiesController());

    final imageUrl = property.coverImage?.imagePath ?? '';
    final image = "${ApiService().baseUrl}/$imageUrl";
    final price = getPropertyPrice(property) ?? 0;
    final isRent = property.rent?.price != null;
    final leasePeriod = property.rent?.leasePeriod ?? 0;

    final country = property.location?.country?.name ?? '';
    final city = property.location?.city?.name ?? '';
    final commercialType =
        property.commercial?.commercialPropertyType?.name ?? '';
    final propertyType = property.propertyType?.name ?? '';
    final residentialType =
        property.residential?.residentialPropertyType?.name ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(() => PropertyDetailsView(property: property));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    image,
                    height: 79.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(Icons.image_not_supported),
                  ),
                ),
                // Positioned(
                //   top: 8,
                //   right: 8,
                //   child: Obx(
                //         () => GestureDetector(
                //       onTap: () {
                //         // savedController.toggleSaved(property.id);
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(4),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black12,
                //               blurRadius: 4,
                //               offset: Offset(2, 2),
                //             ),
                //           ],
                //         ),
                //         child: Icon(
                //           savedController.isSaved(property.id)
                //               ? Icons.bookmark
                //               : Icons.bookmark_border,
                //           color: savedController.isSaved(property.id)
                //               ? AppColors.tabtext
                //               : Colors.grey,
                //           size: 20,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "\$${price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.tabtext,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        isRent ? "/$leasePeriod" : "",
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$country, $city',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    propertyType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  if (property.residential != null)
                    Text(
                      residentialType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    )
                  else if (property.commercial != null)
                    Text(
                      commercialType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
