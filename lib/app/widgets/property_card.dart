import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/colors.dart';
import '../core/theme/themes.dart';
import '../data/services/api_service.dart';

class PropertyCard extends StatelessWidget {
  final String? imageUrl;
  final String? price;
  final String? leasePeriod;
  final String? location;
  final String? propertyType;
  final String? subType;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool? showPayButton;
  final VoidCallback? onPayNow;
  // New parameters for status
  final String? statusText;
  final Color? statusColor;

  const PropertyCard({
    super.key,
    this.imageUrl,
    this.price,
    this.leasePeriod,
    this.location,
    this.propertyType,
    this.subType,
    this.onTap,
    this.onDelete,
    this.showPayButton = false,
    this.onPayNow,
    this.statusText,
    this.statusColor,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Stack(
                children: [
                  _buildImage(imageUrl!),
                  if (onDelete != null)
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: SizedBox(
                        width: 32.w,
                        height: 32.h,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: AppColors.primary,
                            size: 16.w,
                          ),
                          onPressed: onDelete,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.8),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // New status badge
                  if (statusText != null)
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          statusText!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (price != null) _buildPrice(),
                  if (location != null) _buildTextLine(context, location!),
                  if (propertyType != null) _buildTextLine(context, propertyType!),
                  if (subType != null && subType!.isNotEmpty)
                    _buildTextLine(context, subType!),
                  if (showPayButton == true) ...[
                    const SizedBox(height: 12),
                    if (showPayButton == true) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: onPayNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              "Pay Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
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

  Widget _buildImage(String? url) {
    const String defaultImagePath = 'assets/backgrounds/default_placeholder.png';
    final bool hasImage = url != null && url.isNotEmpty;
    final bool isFullUrl =
        url != null && (url.startsWith('http://') || url.startsWith('https://'));
    final String finalUrl = isFullUrl ? url! : "${ApiService().baseUrl}/$url";

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: hasImage
          ? Image.network(
        finalUrl,
        height: 150.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          defaultImagePath,
          height: 150.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      )
          : Image.asset(
        defaultImagePath,
        height: 150.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPrice() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          price!,
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.tabtext,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (leasePeriod != null && leasePeriod!.isNotEmpty) ...[
          SizedBox(width: 4.w),
          Text(
            '/$leasePeriod',
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 8.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
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