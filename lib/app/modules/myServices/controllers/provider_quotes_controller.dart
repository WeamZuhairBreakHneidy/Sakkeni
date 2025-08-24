import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import '../models/provider_quotes_model.dart';
import '../models/submit_quote_request_model.dart';

class ProviderQuotesController extends GetxController {
  var isLoading = false.obs;
  var quotes = <ProviderQuote>[].obs;

  // track expanded quote IDs
  var expandedQuoteIds = <int>[].obs;

  // Text controllers for SubmitQuoteSheetWidget
  final scopeController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void onClose() {
    // Dispose controllers when the controller is removed
    scopeController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.onClose();
  }
  Future<void> fetchProviderQuotes() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: ApiEndpoints.viewServiceProviderQuote,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          final List data = body['data'];
          quotes.value = data.map((e) => ProviderQuote.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Error fetching provider quotes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitQuote(int quoteId, SubmitQuoteRequest request) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.submitQuote}/$quoteId/submit',
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Quote submitted successfully');
        fetchProviderQuotes(); // refresh the list
      } else {
        Get.snackbar('Error', 'Failed to submit quote');
      }
    } catch (e) {
      print("Error submitting quote: $e");
      Get.snackbar('Error', 'Something went wrong');
    }
  }
  Future<void> declineQuote(int quoteId) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.declineQuote}/$quoteId/decline-user-quote',
        body: null, // no body needed
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body['status'] == true) {
          Get.snackbar('Success', body['message'] ?? 'Quote declined successfully');
          fetchProviderQuotes(); // refresh the list
        } else {
          Get.snackbar('Error', body['message'] ?? 'Failed to decline quote');
        }
      } else {
        Get.snackbar('Error', 'Failed to decline quote');
      }
    } catch (e) {
      print("Error declining quote: $e");
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  // toggle expand/collapse
  void toggleExpanded(int quoteId) {
    if (expandedQuoteIds.contains(quoteId)) {
      expandedQuoteIds.remove(quoteId);
    } else {
      expandedQuoteIds.add(quoteId);
    }
  }

  bool isExpanded(int quoteId) => expandedQuoteIds.contains(quoteId);
}
