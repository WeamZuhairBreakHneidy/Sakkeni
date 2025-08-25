import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import '../models/user_quote_model.dart';

class UserQuotesController extends GetxController {
  var isLoading = false.obs;
  var quotes = <UserQuote>[].obs;

  Future<void> fetchUserQuotes() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: ApiEndpoints.viewUserRequests,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          final List data = body['data'];
          quotes.value = data.map((e) => UserQuote.fromJson(e)).toList();

        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to fetch quotes");
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user quotes: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmQuote(int quoteId) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.confirmQuote}/$quoteId/accept',
        body: null,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        Get.snackbar(
          body['status'] == true ? "Success" : "Error",
          body['message'] ?? (body['status'] == true ? "Quote confirmed successfully" : "Failed to confirm quote"),
        );
        if (body['status'] == true) {
          await fetchUserQuotes();
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error confirming quote: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> declineQuote(int quoteId) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.declineQuote}/$quoteId/decline',
        body: null,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        Get.snackbar(
          body['status'] == true ? "Success" : "Error",
          body['message'] ?? (body['status'] == true ? "Quote declined successfully" : "Failed to decline quote"),
        );
        if (body['status'] == true) {
          await fetchUserQuotes();
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error declining quote: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateRequest(int quoteId, String jobDescription) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.updateQuote}/$quoteId/update-request',
        body: {'job_description': jobDescription},
      );

      if (response.statusCode == 200) {
        final body = response.body;
        Get.snackbar(
          body['status'] == true ? "Success" : "Error",
          body['message'] ?? (body['status'] == true ? "Request updated successfully" : "Failed to update request"),
        );
        if (body['status'] == true) {
          await fetchUserQuotes();
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating request: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> payQuote(int quoteId) async {
    try {
      // 🔹 Placeholder for payment integration
      Get.snackbar("Success", "Proceeding to payment for Quote $quoteId");
    } catch (e) {
      print("Error processing payment: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> markAsComplete(int quoteId) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.markServiceAsCompleted}/$quoteId/complete',
        body: null,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        Get.snackbar(
          body['status'] == true ? "Success" : "Error",
          body['message'] ?? (body['status'] == true ? "Service marked as complete" : "Failed to mark service as complete"),
        );
        if (body['status'] == true) {
          await fetchUserQuotes();
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error marking service as complete: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> rateService(int serviceActivityId, int rating, String reviewText) async {
    try {
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.rateService}/$serviceActivityId/submitReview',
        body: {
          'rating': rating,
          'review_text': reviewText,
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        Get.snackbar(
          body['status'] == true ? "Success" : "Error",
          body['message'] ?? (body['status'] == true ? "Review submitted successfully" : "Failed to submit review"),
        );
        if (body['status'] == true) {
          await fetchUserQuotes();
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error submitting review: $e");
      Get.snackbar("Error", e.toString());
    }
  }
}