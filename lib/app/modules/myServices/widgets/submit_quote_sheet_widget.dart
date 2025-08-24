import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/colors.dart';
import '../../../data/services/validator_service.dart';
import '../controllers/provider_quotes_controller.dart';
import '../models/provider_quotes_model.dart';
import '../../../widgets/input_text_form_field.dart';
import '../models/submit_quote_request_model.dart';
class SubmitQuoteSheetWidget extends StatelessWidget {
  final ProviderQuote quote;
  final ProviderQuotesController controller;

  SubmitQuoteSheetWidget({super.key, required this.quote, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              Text(
                "Accept Request",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),

              _buildLabel("Scope of Work"),
              TextField(
                controller: controller.scopeController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Enter the scope of work in detail...",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 20.h),

              _buildLabel("Amount"),
              InputTextFormField(
                textEditingController: controller.amountController,
                validatorType: ValidatorType.Number,
                obsecure: false,
                hintText: "Enter price (e.g. 250.00)",
                prefixIcon: Icon(Icons.attach_money, color: AppColors.primary),
              ),
              SizedBox(height: 20.h),

              _buildLabel("Start Date"),
              TextField(
                controller: controller.dateController,
                readOnly: true,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12.r,
                ),
                decoration: InputDecoration(
                  hintText: "Pick a date",
                  suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                  border: const OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.dateController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
              ),
              SizedBox(height: 30.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text("Cancel", style: theme.textTheme.labelMedium),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitQuote,
                      icon: Icon(Icons.check_circle),
                      label: Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(label, style: Theme.of(Get.context!).textTheme.labelLarge),
    );
  }

  void _submitQuote() {
    if (controller.scopeController.text.isNotEmpty &&
        controller.amountController.text.isNotEmpty &&
        controller.dateController.text.isNotEmpty) {
      final request = SubmitQuoteRequest(
        scopeOfWork: controller.scopeController.text,
        amount: controller.amountController.text,
        startDate: controller.dateController.text,
      );

      controller.submitQuote(quote.id, request);

      // Clear the text controllers after submitting
      controller.scopeController.clear();
      controller.amountController.clear();
      controller.dateController.clear();
    } else {
      Get.snackbar("Error", "Please fill all fields");
    }
  }

}
