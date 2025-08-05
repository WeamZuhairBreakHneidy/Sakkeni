//... الكود في الأعلى كما هو
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../data/services/api_service.dart';
import '../controllers/expandable_text_controller.dart';
import '../controllers/property_details_controller.dart';
import '../models/property_details_model.dart' as property_model;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyDetailsView extends GetView<PropertyDetailsController> {
  const PropertyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
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
        } else if (controller.propertyDetails.value == null ||
            controller.propertyDetails.value!.data == null) {
          return const Center(child: Text('No property details found.'));
        } else {
          final property_model.Data property =
          controller.propertyDetails.value!.data!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 75.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250.h,
                        child: PageView.builder(
                          controller: controller.pageController,
                          itemCount: property.images.length,
                          onPageChanged: (index) {
                            controller.currentImageIndex.value = index;
                          },
                          itemBuilder: (context, index) {
                            final imagePath = property.images[index].imagePath;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child:
                                imagePath.isNotEmpty
                                    ? Image.network(
                                  '${ApiService().baseUrl}/${imagePath.trim()}',
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.broken_image,
                                    size: 100,
                                  ),
                                )
                                    : Image.asset(
                                  'assets/Logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (property.images.length > 1)
                        Obx(
                              () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            property.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.w,
                                height: 8.h,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                  controller.currentImageIndex.value ==
                                      entry.key
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (property.purchase?.price != null)
                        Text(
                          '\$${property.purchase?.price.toStringAsFixed(0) ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20.sp,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              '${property.location?.city?.name ?? 'N/A'}, ${property.location?.country?.name ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildDetailRow(context, [
                        _buildDetailItem(
                          Icons.square_foot,
                          'Area',
                          '${property.area ?? 'N/A'} sqm',
                        ),
                        _buildDetailItem(
                          Icons.bathtub,
                          'Bathrooms',
                          property.bathrooms.toString() ?? 'N/A',
                        ),
                        _buildDetailItem(
                          Icons.balcony,
                          'Balconies',
                          property.balconies.toString() ?? 'N/A',
                        ),
                      ]),
                      SizedBox(height: 16.h),
                      _buildInfoTile(
                        'Property Type',
                        property.propertyType?.name ?? 'N/A',
                      ),
                      _buildInfoTile(
                        'Ownership Type',
                        property.ownershipType?.name ?? 'N/A',
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle('Owner Information'),
                      _buildInfoTile(
                        'Name',
                        '${property.owner?.firstName ?? ''} ${property.owner?.lastName ?? ''}',
                      ),
                      _buildInfoTile('Email', property.owner?.email ?? 'N/A'),
                      _buildInfoTile(
                        'Phone',
                        property.owner?.phoneNumber ?? 'N/A',
                      ),
                      SizedBox(height: 16.h),
                      if (property.residential != null) ...[
                        _buildSectionTitle('Residential Details'),
                        _buildInfoTile(
                          'Bedrooms',
                          property.residential!.bedrooms.toString(),
                        ),
                        _buildInfoTile(
                          'Residential Type',
                          property.residential!.residentialPropertyType?.name ??
                              'N/A',
                        ),
                        SizedBox(height: 5.h),
                        if (property.purchase != null)
                          _buildFurnishedStatus(property.purchase!.isFurnished),
                        SizedBox(height: 16.h),
                      ],
                      if (property.amenities.isNotEmpty) ...[
                        _buildSectionTitle('Amenities'),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children:
                          property.amenities
                              .map(
                                (amenity) => Chip(
                              label: Text(amenity.name ?? ''),
                              backgroundColor: Colors.blue.withOpacity(
                                0.1,
                              ),
                            ),
                          )
                              .toList(),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (property.directions.isNotEmpty) ...[
                        _buildSectionTitle('Directions'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          property.directions
                              .map(
                                (direction) => Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                '- ${direction.name ?? ''}',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (property.description != null && property.description.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Description'),
                            Text(
                              'Ai generated',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        ExpandableText(
                          property.description,
                          trimLines: 3,
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: AppColors.primary),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }
}

Widget _buildFurnishedStatus(num isFurnished) {
  final bool furnished = isFurnished == 1;
  final String label = furnished ? 'Furnished' : 'Unfurnished';
  final IconData icon = furnished ? Icons.chair : Icons.bed;
  final Color color = furnished ? AppColors.primary : Colors.grey;

  return Row(
    children: [
      Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
      Text(
        '',
        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      ),
      SizedBox(width: 4.h),
    ],
  );
}

class ExpandableText extends GetView<ExpandableTextController> {
  final String text;
  final int trimLines;

  const ExpandableText(
      this.text, {
        super.key,
        this.trimLines = 3,
      }) : super();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExpandableTextController>(tag: text)) {
      Get.put(ExpandableTextController(), tag: text);
    }

    final controller = Get.find<ExpandableTextController>(tag: text);

    final defaultTextStyle = TextStyle(
      fontSize: 14.sp,
      color: Colors.black87,
      height: 1.5,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: defaultTextStyle),
      maxLines: trimLines,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32.w);

    final bool hasMoreText = textPainter.didExceedMaxLines;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isExpanded.value)
            Text(
              text,
              style: defaultTextStyle,
            )
          else
            Text(
              text,
              style: defaultTextStyle,
              maxLines: trimLines,
              overflow: TextOverflow.ellipsis,
            ),
          if (hasMoreText)
            GestureDetector(
              onTap: controller.toggleExpanded,
              child: Text(
                controller.isExpanded.value ? 'Show Less' : 'Read More',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      );
    });
  }
}