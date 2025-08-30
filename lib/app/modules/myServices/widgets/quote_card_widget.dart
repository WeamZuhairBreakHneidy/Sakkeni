import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../../data/services/api_endpoints.dart';
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
                        ? NetworkImage("${ApiEndpoints.baseUrl}/${quote.user.profilePicturePath}")
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
              _buildStatusBadge(context, quote),
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

  Widget _buildStatusBadge(BuildContext context, ProviderQuote quote) {
    final theme = Theme.of(context);
    String displayStatus = quote.status;
    Color statusColor;

    // Determine status and color based on quote status or service activity status
    if (quote.serviceActivity != null) {
      displayStatus = quote.serviceActivity!.status;
      switch (quote.serviceActivity!.status) {
        case "Awaiting Payment":
          statusColor = Colors.orange;
          break;
        case "In Progress":
          statusColor = Colors.blue;
          break;
        case "Completed":
          statusColor = Colors.purple;
          break;
        case "Rated":
          statusColor = Colors.deepOrange;
          break;
        default:
          statusColor = Colors.grey;
      }
    } else {
      switch (quote.status.toLowerCase()) {
        case "pending provider response":
          statusColor = Colors.grey.shade600;
          break;
        case "pending user acceptance":
          displayStatus = "Pending User Acceptance";
          statusColor = Colors.green.shade400; // Slightly lighter green to differentiate
          break;
        case "accepted":
          statusColor = Colors.green;
          break;
        case "declined":
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.grey;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        displayStatus.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }

  List<Widget> _expandedContent(BuildContext context, ProviderQuote quote) {
    final theme = Theme.of(context);
    List<Widget> content = [];

    // Provider-friendly instruction message
    content.add(_buildInstructionMessage(context, quote));
    content.add(SizedBox(height: 12.h));

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

    // Service Activity Details
    if (quote.serviceActivity != null) {
      content.add(Text("Service Activity", style: theme.textTheme.titleMedium));
      content.add(SizedBox(height: 6.h));
      content.add(Row(
        children: [
          Text(
            "Status: ",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            quote.serviceActivity!.status,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _getStatusColor(quote.serviceActivity!.status),
            ),
          ),
        ],
      ));
      content.add(SizedBox(height: 6.h));
      content.add(Text(
        "Start Date: ${quote.serviceActivity!.startDate}",
        style: theme.textTheme.bodyMedium,
      ));
      if (quote.serviceActivity!.estimatedEndDate != null) {
        content.add(SizedBox(height: 4.h));
        content.add(Text(
          "Estimated End Date: ${quote.serviceActivity!.estimatedEndDate}",
          style: theme.textTheme.bodyMedium,
        ));
      }
      content.add(SizedBox(height: 12.h));
    }

    // Action Buttons for Pending Provider Response
    content.add(_buildActionButtons(context, quote));

    return content;
  }

  Widget _buildInstructionMessage(BuildContext context, ProviderQuote quote) {
    final theme = Theme.of(context);
    String message;
    Color messageColor;

    if (quote.serviceActivity != null) {
      switch (quote.serviceActivity!.status) {
        case "Awaiting Payment":
          message = "Waiting for payment from ${quote.user.firstName} to start the service.";
          messageColor = Colors.orange;
          break;
        case "In Progress":
          message = "The service has started. You can chat with ${quote.user.firstName} to get more info.";
          messageColor = Colors.blue;
          break;
        case "Completed":
          message = "The service for ${quote.user.firstName} is completed. Waiting for their review.";
          messageColor = Colors.purple;
          break;
        case "Rated":
          message = "The service for ${quote.user.firstName} has been rated.";
          messageColor = Colors.deepOrange;
          break;
        default:
          message = "Unknown service status for ${quote.user.firstName}'s request.";
          messageColor = Colors.grey;
      }
    } else {
      switch (quote.status.toLowerCase()) {
        case "pending provider response":
          message = "Review the request from ${quote.user.firstName} and submit your quote or decline.";
          messageColor = Colors.grey.shade600;
          break;
        case "pending user acceptance":
          message = "Waiting for ${quote.user.firstName} to accept the offer.";
          messageColor = Colors.green.shade400;
          break;
        case "accepted":
          message = "Your quote for ${quote.user.firstName} has been accepted. Waiting for payment to proceed.";
          messageColor = Colors.green;
          break;
        case "declined":
          message = "You have declined the request from ${quote.user.firstName}.";
          messageColor = Colors.red;
          break;
        default:
          message = "Unknown status for ${quote.user.firstName}'s request.";
          messageColor = Colors.grey;
      }
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: messageColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: messageColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Awaiting Payment":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Completed":
        return Colors.purple;
      case "Rated":
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionButtons(BuildContext context, ProviderQuote quote) {
    List<Widget> buttons = [];

    void addButton(String title, Color color, VoidCallback onTap) {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      );
    }

    final statusLower = quote.status.toLowerCase();
    if (statusLower == "pending provider response") {
      addButton("Submit Quote", Colors.green.shade600, () => _showBottomSheet(quote));
      buttons.add(SizedBox(width: 12.w));
      addButton("Decline", Colors.red.shade600, () => _confirmDecline(quote.id));
    }

    return buttons.isNotEmpty ? Row(children: buttons) : SizedBox.shrink();
  }

  void _showConfirmation(String title, ProviderQuote quote, VoidCallback onConfirm) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        backgroundColor: Theme.of(Get.context!).cardColor,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                title == "Decline" ? Icons.cancel : Icons.check_circle_outline,
                color: title == "Decline" ? Colors.red.shade400 : Colors.blue,
                size: 48.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                "Confirm $title",
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Are you sure you want to $title this quote?",
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
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: title == "Decline" ? Colors.red.shade600 : Colors.blue,
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

  void _confirmDecline(int quoteId) {
    _showConfirmation("Decline", quote, () => controller.declineQuote(quoteId));
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