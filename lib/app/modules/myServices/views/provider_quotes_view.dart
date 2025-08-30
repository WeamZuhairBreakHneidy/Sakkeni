import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../controllers/provider_quotes_controller.dart';
import '../widgets/quote_card_widget.dart';

class ProviderQuotesView extends GetView<ProviderQuotesController> {
  const ProviderQuotesView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchProviderQuotes(); // initial fetch
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Custom header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50.h, bottom: 24.h),
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
                "Requests to do",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Summary Section for Pending, Awaiting Payment, In Progress, Completed, and Rated
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final pendingResponseCount = controller.quotes
                    .where((quote) => quote.status == "Pending Provider Response")
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
                final ratedCount = controller.quotes
                    .where((quote) => quote.serviceActivity?.status == "Rated")
                    .length;

                return Row(
                  children: [
                    _buildSummaryCard(
                      title: "Pending",
                      count: pendingResponseCount,
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
                    SizedBox(width: 8.w),
                    _buildSummaryCard(
                      title: "Rated",
                      count: ratedCount,
                      color: Colors.deepOrange,
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
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.quotes.isEmpty) {
                return Center(
                  child: Text("No Requests Found", style: theme.textTheme.bodyLarge),
                );
              }

              // Wrap ListView in RefreshIndicator
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchProviderQuotes();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.quotes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final quote = controller.quotes[index];
                      return QuoteCardWidget(quote: quote);
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
}