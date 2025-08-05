import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';
import 'package:test1/app/data/services/api_service.dart';
import 'package:test1/app/modules/home/controllers/home_controller.dart';
import 'package:test1/app/widgets/property_card.dart';
import 'package:test1/app/data/models/properties-model.dart';

class RecommendedProperties extends GetView<HomeController> {
  const RecommendedProperties({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10.h),
          Obx(() {
            final props = controller.allProperties;
            final isLoading = controller.isLoading.value;

            if (props.isEmpty && isLoading) {
              return Center(
                child: SizedBox(
                  width: 75.w,
                  height: 75.h,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    colors: [AppColors.primary],
                    strokeWidth: 1,
                  ),
                ),
              );
            }

            // عرض رسالة إذا لم يتم العثور على عقارات
            if (props.isEmpty && !isLoading) {
              return const Center(child: Text("No recommended properties found."));
            }

            // عرض القائمة عند توفر البيانات
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: props.length,
              itemBuilder: (context, index) {
                final Datum property = props[index];

                final String imageUrl;
                String? imagePath = property.coverImage?.imagePath;
                if (imagePath != null && imagePath.isNotEmpty) {
                  imageUrl = "${ApiService().baseUrl}/$imagePath";
                } else {
                  imageUrl = 'https://via.placeholder.com/150';
                }

                final price =
                    property.rent?.price.toStringAsFixed(0) ??
                        property.purchase?.price.toStringAsFixed(0) ??
                        property.offplan?.overallPayment.toStringAsFixed(0) ??
                        '0';

                final location =
                    "${property.location?.country?.name ?? ''}, ${property.location?.city?.name ?? ''}";
                final lease = property.rent?.leasePeriod.toString() ?? '';
                final propertyType = property.propertyType?.name ?? '';
                final subType =
                    property.residential?.residentialPropertyType?.name ??
                        property.commercial?.commercialPropertyType?.name ??
                        '';

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: SizedBox(
                    height: 200.h,
                    child: PropertyCard(
                      imageUrl: imageUrl,
                      price: "\$$price",
                      leasePeriod: lease,
                      location: location,
                      propertyType: propertyType,
                      subType: subType,
                      onTap: () {
                        // هنا يمكنك إضافة منطق للانتقال إلى صفحة تفاصيل العقار
                        // مثال: Get.toNamed(Routes.PROPERTY_DETAILS, arguments: property.id);
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}