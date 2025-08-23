import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../controllers/provider_quotes_controller.dart';
import '../models/provider_quotes_model.dart';
import 'submit_quote_sheet_widget.dart';

class QuoteCardWidget extends GetView<ProviderQuotesController> {
  final ProviderQuote quote;
  const QuoteCardWidget({required this.quote, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isExpanded = controller.isExpanded(quote.id);

      return Card(
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    backgroundImage: quote.user.profilePicturePath != null
                        ? NetworkImage(quote.user.profilePicturePath!)
                        : null,
                    child: quote.user.profilePicturePath == null
                        ? Icon(Icons.person, color: AppColors.primary, size: 28.sp)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${quote.user.firstName} ${quote.user.lastName}",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          quote.service.name,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildStatusBadge(context, quote.status),
              SizedBox(height: 12.h),

              if (isExpanded) ..._expandedContent(context, quote),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => controller.toggleExpanded(quote.id),
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  label: Text(isExpanded ? "Collapse" : "See More"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  List<Widget> _expandedContent(BuildContext context, ProviderQuote quote) {
    final theme = Theme.of(context);
    List<Widget> content = [];

    if (quote.amount != null) {
      content.add(Text("Amount", style: theme.textTheme.titleMedium));
      content.add(SizedBox(height: 4.h));
      content.add(Text("\$${quote.amount}", style: theme.textTheme.bodyLarge));
      content.add(SizedBox(height: 12.h));
    }

    if (quote.scopeOfWork != null) {
      content.add(Text("Scope of Work", style: theme.textTheme.titleMedium));
      content.add(SizedBox(height: 4.h));
      content.add(Text(quote.scopeOfWork!, style: theme.textTheme.bodyMedium));
      content.add(SizedBox(height: 12.h));
    }

    content.add(Text("Job Description", style: theme.textTheme.titleMedium));
    content.add(SizedBox(height: 4.h));
    content.add(Text(quote.jobDescription, style: theme.textTheme.bodyMedium));
    content.add(SizedBox(height: 16.h));

    final statusLower = quote.status.toLowerCase();
    if (statusLower != "pending user acceptance" && statusLower != "declined") {
      content.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () => _showBottomSheet(quote),
            icon: const Icon(Icons.check_circle),
            label: const Text("Accept"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
          ),
          SizedBox(width: 12.w),
          ElevatedButton.icon(
            onPressed: () => _confirmDecline(quote.id),
            icon: const Icon(Icons.cancel),
            label: const Text("Decline"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
          ),
        ],
      ));
    }

    content.add(SizedBox(height: 12.h));
    return content;
  }

// New confirmation dialog
  void _confirmDecline(int quoteId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        backgroundColor: Theme.of(Get.context!).cardColor,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.red.shade400, size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                "Confirm Decline",
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Are you sure you want to decline this quote?",
                textAlign: TextAlign.center,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "No",
                      style: TextStyle(color: Theme.of(Get.context!).primaryColor),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.declineQuote(quoteId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }

  void _showBottomSheet(ProviderQuote quote) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Theme.of(Get.context!).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => SubmitQuoteSheetWidget(quote: quote, controller: controller),
    );
  }
}
