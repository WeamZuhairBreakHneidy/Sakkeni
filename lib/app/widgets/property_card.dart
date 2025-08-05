import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/colors.dart';
import '../core/theme/themes.dart';

class PropertyCard extends StatelessWidget {
  final String? imageUrl;
  final String? price;
  final String? leasePeriod;
  final String? location;
  final String? propertyType;
  final String? subType;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    this.imageUrl,
    this.price,
    this.leasePeriod,
    this.location,
    this.propertyType,
    this.subType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        decoration: _cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null) _buildImage(imageUrl!),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(13.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (price != null) _buildPrice(),
                    if (location != null) _buildTextLine(context, location!),
                    if (propertyType != null)
                      _buildTextLine(context, propertyType!),
                    if (subType != null && subType!.isNotEmpty)
                      _buildTextLine(context, subType!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.background,
    borderRadius: BorderRadius.circular(16.r),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 6.r,
        offset: Offset(0, 3),
      ),
    ],
  );

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        url,
        height: 150.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      ),
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Expanded(
          child: Text(
            price!,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.tabtext,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (leasePeriod != null && leasePeriod!.isNotEmpty) ...[
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              '/$leasePeriod',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextLine(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
