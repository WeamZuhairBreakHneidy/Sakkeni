import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class UpgradeToServiceProviderController extends GetxController {
  var isLoading = false.obs;

  // Observables
  final RxInt selectedPlanId = 0.obs;       // مش Nullable
  final RxList<int> selectedServices = <int>[].obs;
  final RxString description = ''.obs;

  final box = GetStorage();

  /// Select subscription plan
  void selectPlan(int planId) {
    selectedPlanId.value = planId;
  }

  /// Select or deselect a service
  void toggleService(int serviceId) {
    if (selectedServices.contains(serviceId)) {
      selectedServices.remove(serviceId);
    } else {
      selectedServices.add(serviceId);
    }
  }

  /// Set description
  void setDescription(String text) {
    description.value = text;
  }

  /// Upgrade account to Service Provider
  Future<void> upgradeToServiceProvider() async {
    if (selectedPlanId.value == 0) {
      Get.snackbar(
        "Error",
        "Please select a subscription plan.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (selectedServices.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one service.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (description.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a description.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService().postApi(
        url: ApiEndpoints.upgradeToServiceProvider,
        body: {
          "subscription_plan_id": selectedPlanId.value,
          "services_id": selectedServices,
          "description": description.value,
        },
      );

      final body = response.body;
      final message = body['message'];

      if (response.statusCode == 200) {
        final status = body['status'];

        if (status == true) {
          // Save state locally
          GetStorage().write('isServiceProvider', true);

          Get.snackbar(
            'Success',
            message ?? 'Upgraded to service provider successfully',
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
          );

          Get.offAllNamed(Routes.HOME);
        } else {
          _handleErrorMessage(message, body);
        }
      } else {
        Get.snackbar(
          'Upgrade Failed',
          'Something went wrong (${response.statusCode}). Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final errorMessage = e.toString();
      print("UpgradeToServiceProvider Error: $errorMessage");

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _handleErrorMessage(String? message, dynamic body) {
    String errorMessage = message ?? 'Unknown error';
    if (body['errors'] != null) {
      body['errors'].forEach((key, value) {
        errorMessage += "\n${value.join(', ')}";
      });
    }
    Get.snackbar(
      'Upgrade Failed',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
