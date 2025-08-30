import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class SabscruptionController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final json = box.read('user');
    if (json != null) {
      user.value = UserModel.fromJson(Map<String, dynamic>.from(json));
    }
  }

  Future<void> makePayment() async {
    isLoading.value = true;
    final currentUser = user.value;

    if (currentUser == null) {
      Get.snackbar('Error', 'User not logged in. Please log in to proceed.');
      isLoading.value = false;
      return;
    }

    try {
      // 1) نطلب clientSecret من الباكند
      final response = await ApiService().postApi(
        url: '${ApiEndpoints.subscription}',
        body: {},
        headers: {
          'Authorization': 'Bearer ${currentUser.token}',
          'Accept': 'application/json',
        },
      );

      final body = response.body;
      print("Backend Response: $body");

      if (response.statusCode == 200 && body['status'] == true) {
        final clientSecret = body['data']['clientSecret'];
        print("Client Secret: $clientSecret");

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Sakkeni',
            style: ThemeMode.light,
            billingDetails: BillingDetails(
              email: currentUser.email,
            ),
          ),
        );

        // 3) عرض واجهة الدفع
        await Stripe.instance.presentPaymentSheet();

        Get.snackbar(
          'Success',
          'Payment successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.MY_SERVICES);
      } else {
        Get.snackbar(
          'Payment Failed',
          body['message'] ?? 'Failed to create payment intent.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on StripeException catch (e) {
      Get.snackbar(
        'Payment Failed',
        e.error.localizedMessage ?? 'An unknown error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Stripe Error: ${e.error.localizedMessage}');
    } catch (e) {
      print('Generic Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
