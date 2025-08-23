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
                  "Your Requests",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      physics: const AlwaysScrollableScrollPhysics(), // ensures pull even if list is short
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
  }
