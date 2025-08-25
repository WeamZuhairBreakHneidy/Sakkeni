import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../controllers/user_quotes_controller.dart';
import '../models/user_quote_model.dart';

class UserQuotesView extends GetView<UserQuotesController> {
  const UserQuotesView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchUserQuotes(); // initial fetch
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Center(
              child: Text(
                "User Requests",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ),

          // Summary Section for Pending User Acceptance, Awaiting Payment, In Progress, and Completed
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final pendingAcceptanceCount = controller.quotes
                    .where((quote) => quote.status == "Pending User Acceptance")
                    .length;
                final awaitingPaymentCount = controller.quotes
                    .where((quote) => quote.serviceActivity?.status == "Awaiting Payment")
                    .length;
                final inProgressCount = controller.quotes
                    .where((quote) => quote.serviceActivity?.status == "In Progress")
                    .length;
                final completedCount = controller.quotes
                    .where((quote) => quote.serviceActivity?.status == "Completed")
                    .length;

                return Row(
                  children: [
                    _buildSummaryCard(
                      title: "Pending",
                      count: pendingAcceptanceCount,
                      color: Colors.green,
                      theme: theme,
                      width: 100.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryCard(
                      title: "Payment",
                      count: awaitingPaymentCount,
                      color: Colors.orange,
                      theme: theme,
                      width: 100.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryCard(
                      title: "In Progress",
                      count: inProgressCount,
                      color: Colors.blue,
                      theme: theme,
                      width: 100.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryCard(
                      title: "Completed",
                      count: completedCount,
                      color: Colors.purple,
                      theme: theme,
                      width: 100.w,
                      height: 70.h,
                    ),
                  ],
                );
              }),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.quotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 48.r, color: AppColors.gray3),
                      SizedBox(height: 8.h),
                      Text(
                        "No Requests Found",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.gray1,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => controller.fetchUserQuotes(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.quotes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final quote = controller.quotes[index];
                      return _buildQuoteCard(quote, theme);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required Color color,
    required ThemeData theme,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray1,
              fontSize: 12.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(UserQuote quote, ThemeData theme) {
    // Status colors
    Color statusColor;
    switch (quote.status) {
      case "Pending Provider Response":
        statusColor = Colors.grey.shade600;
        break;
      case "Pending User Acceptance":
        statusColor = Colors.green;
        break;
      case "Awaiting Payment":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Service activity status color
    Color? activityStatusColor;
    if (quote.serviceActivity != null) {
      switch (quote.serviceActivity!.status) {
        case "Awaiting Payment":
          activityStatusColor = Colors.orange;
          break;
        case "In Progress":
          activityStatusColor = Colors.blue;
          break;
        case "Completed":
          activityStatusColor = Colors.purple;
          break;
        default:
          activityStatusColor = Colors.grey;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.surface.withOpacity(0.95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: service + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    quote.service.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    quote.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // User Description
            Text(
              "Your Request",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              quote.jobDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray1,
                fontSize: 14.sp,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),

            // Provider Scope
            if (quote.scopeOfWork != null) ...[
              Text(
                "Provider's Response",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                quote.scopeOfWork!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray1,
                  fontSize: 14.sp,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
            ],

            // Cost (show only serviceActivity.cost if available, to avoid duplication)
            if (quote.serviceActivity != null && quote.serviceActivity!.cost != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "\$${quote.serviceActivity!.cost}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              )
            else if (quote.amount != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "\$${quote.amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            SizedBox(height: 8.h),

            // Service Activity
            if (quote.serviceActivity != null) ...[
              Text(
                "Service Activity",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: activityStatusColor?.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      quote.serviceActivity!.status,
                      style: TextStyle(
                        color: activityStatusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                "Start Date: ${quote.serviceActivity!.startDate}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray1,
                  fontSize: 14.sp,
                ),
              ),
              if (quote.serviceActivity!.estimatedEndDate != null) ...[
                SizedBox(height: 4.h),
                Text(
                  "Estimated End Date: ${quote.serviceActivity!.estimatedEndDate}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.gray1,
                    fontSize: 14.sp,
                  ),
                ),
              ],
              SizedBox(height: 8.h),
            ],

            // Action Buttons
            _buildActionButtons(quote, activityStatusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(UserQuote quote, Color? activityStatusColor) {
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
              elevation: 2,
              shadowColor: color.withOpacity(0.3),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    // Add buttons based on quote status
    switch (quote.status) {
      case "Pending Provider Response":
        addButton("Update Request", Colors.grey.shade700, () {
          _showUpdateRequestDialog(quote);
        });
        break;

      case "Pending User Acceptance":
        addButton("Confirm", Colors.green, () {
          _showConfirmation("Confirm", quote, () => controller.confirmQuote(quote.id));
        });
        buttons.add(SizedBox(width: 8.w));
        addButton("Decline", Colors.red, () {
          _showConfirmation("Decline", quote, () => controller.declineQuote(quote.id));
        });
        break;
    }

    // Add "Pay Now" button if serviceActivity status is "Awaiting Payment"
    if (quote.serviceActivity?.status == "Awaiting Payment") {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(width: 8.w));
      }
      addButton("Pay Now", Colors.orange, () {
        _showConfirmation("Pay Now", quote, () => controller.payQuote(quote.id));
      });
    }

    // Add "Mark as Complete" button if serviceActivity status is "In Progress"
    if (quote.serviceActivity?.status == "In Progress") {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(width: 8.w));
      }
      addButton("Mark as Complete", Colors.blue, () {
        _showConfirmation("Mark as Complete", quote, () => controller.markAsComplete(quote.id));
      });
    }

    // Add "Rate Service" button if serviceActivity status is "Completed"
    if (quote.serviceActivity?.status == "Completed") {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(width: 8.w));
      }
      addButton("Rate Service", Colors.purple, () {
        _showRateServiceDialog(quote);
      });
    }

    return Row(children: buttons);
  }

  void _showConfirmation(String title, UserQuote quote, VoidCallback onConfirm) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 320.w, minWidth: 280.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray2.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    title == "Pay Now"
                        ? Icons.payment
                        : title == "Confirm"
                        ? Icons.check_circle
                        : title == "Decline"
                        ? Icons.cancel
                        : title == "Mark as Complete"
                        ? Icons.check_circle_outline
                        : title == "Rate Service"
                        ? Icons.star
                        : Icons.edit,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      title == "Pay Now" ? "Confirm Payment" : "Confirm $title",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  title == "Pay Now"
                      ? "Are you sure you want to proceed with the payment of \$${quote.serviceActivity!.cost} for ${quote.service.name}?"
                      : title == "Confirm"
                      ? "Are you sure you want to confirm the quote for ${quote.service.name}?"
                      : title == "Decline"
                      ? "Are you sure you want to decline the quote for ${quote.service.name}?"
                      : title == "Mark as Complete"
                      ? "Are you sure you want to mark the service for ${quote.service.name} as complete?"
                      : title == "Rate Service"
                      ? "Are you sure you want to submit a review for ${quote.service.name}?"
                      : "Are you sure you want to update the request for ${quote.service.name}?",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.gray1,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: title == "Pay Now"
                          ? Colors.orange
                          : title == "Confirm"
                          ? Colors.green
                          : title == "Decline"
                          ? Colors.red
                          : title == "Mark as Complete"
                          ? Colors.blue
                          : title == "Rate Service"
                          ? Colors.purple
                          : Colors.grey.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateRequestDialog(UserQuote quote) {
    final TextEditingController jobDescriptionController = TextEditingController(
      text: quote.jobDescription,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 320.w, minWidth: 280.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray2.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      "Update Request",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  "Update the job description for ${quote.service.name}:",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.gray1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: jobDescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.gray2),
                  ),
                  hintText: "Enter new job description",
                  hintStyle: TextStyle(color: AppColors.gray3, fontSize: 14.sp),
                ),
                style: TextStyle(fontSize: 14.sp, color: AppColors.gray1),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      if (jobDescriptionController.text.trim().isNotEmpty) {
                        Get.back();
                        _showConfirmation(
                          "Update Request",
                          quote,
                              () => controller.updateRequest(quote.id, jobDescriptionController.text.trim()),
                        );
                      } else {
                        Get.snackbar("Error", "Job description cannot be empty");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRateServiceDialog(UserQuote quote) {
    final TextEditingController reviewController = TextEditingController();
    var rating = 5.obs; // Default rating

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 320.w, minWidth: 280.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray2.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      "Rate Service",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  "Rate the service for ${quote.service.name}:",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.gray1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 24.r,
                    ),
                    onPressed: () => rating.value = index + 1,
                  );
                }),
              )),
              SizedBox(height: 8.h),
              TextField(
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.gray2),
                  ),
                  hintText: "Enter your review",
                  hintStyle: TextStyle(color: AppColors.gray3, fontSize: 14.sp),
                ),
                style: TextStyle(fontSize: 14.sp, color: AppColors.gray1),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      if (reviewController.text.trim().isNotEmpty) {
                        Get.back();
                        _showConfirmation(
                          "Rate Service",
                          quote,
                              () => controller.rateService(
                            quote.serviceActivity!.id,
                            rating.value,
                            reviewController.text.trim(),
                          ),
                        );
                      } else {
                        Get.snackbar("Error", "Review text cannot be empty");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}