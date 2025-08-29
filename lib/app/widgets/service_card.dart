import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test1/app/core/theme/colors.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;
  final String availabilityStatus;
  final String categoryName;
  final DateTime? createdAt;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final VoidCallback? onEdit;

  const ServiceCard({
    Key? key,
    required this.serviceName,
    required this.categoryName,
    required this.description,
    required this.availabilityStatus,
    this.createdAt,
    this.onTap,
    this.onDismissed,
    this.onEdit,
  }) : super(key: key);

  // Helper method to get the status color and text
  Map<String, dynamic> _getStatusStyle() {
    switch (availabilityStatus.toLowerCase()) {
      case 'pending':
        return {
          'color': Colors.orange,
          'text': 'Pending',
          'icon': Icons.timelapse
        };
      case 'available':
        return {
          'color': Colors.green,
          'text': 'Available',
          'icon': Icons.check_circle
        };
      case 'unavailable':
        return {
          'color': Colors.red,
          'text': 'Unavailable',
          'icon': Icons.cancel
        };
      default:
        return {
          'color': Colors.grey,
          'text': 'N/A',
          'icon': Icons.help_outline
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = createdAt != null
        ? "${createdAt!.day}/${createdAt!.month}/${createdAt!.year}"
        : "N/A";

    final statusStyle = _getStatusStyle();
    final statusColor = statusStyle['color'] as Color;
    final statusText = statusStyle['text'] as String;
    final statusIcon = statusStyle['icon'] as IconData;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: AppColors.gray3,
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: AppColors.gray3,
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        if (onDismissed != null) {
          onDismissed!();
        }
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        shadowColor: AppColors.primary,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Column(
            children: [
              // خط ملون بالأعلى
              Container(
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.gray3.withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
              ),

              // 🔹 زر Edit أعلى الكارد
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: onEdit,
                  tooltip: "Edit Service",
                ),
              ),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serviceName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Chip(
                          avatar: Icon(statusIcon,
                              color: Colors.white, size: 18.sp),
                          backgroundColor: statusColor,
                          label: Text(
                            statusText,
                            style: TextStyle(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    // Description
                    Text(
                      description.isNotEmpty
                          ? description
                          : "No description available",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.verticalSpace,
                    // Category
                    Row(
                      children: [
                        Icon(Icons.category,
                            size: 16.sp, color: AppColors.primary),
                        6.horizontalSpace,
                        Text(
                          categoryName.isNotEmpty
                              ? categoryName
                              : 'No Category',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    // Footer: Created At + Progress bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "📅 $formattedDate",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 80.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: statusText == "Available"
                                ? 1
                                : statusText == "Pending"
                                ? 0.6
                                : 0.3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
