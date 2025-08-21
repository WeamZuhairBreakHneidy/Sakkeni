import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class UpgradeToServiceProviderController extends GetxController {
  var selectedServices = <int>[].obs;
  var selectedPlanId = 0.obs;
  var expandedCategoryIds = <int>[].obs;

  void toggleCategory(int id) {
    if (expandedCategoryIds.contains(id)) {
      expandedCategoryIds.remove(id);
    } else {
      expandedCategoryIds.add(id);
    }
  }
  var description = ''.obs;
  var isLoading = false.obs;

  void toggleService(int serviceId) {
    if (selectedServices.contains(serviceId)) {
      selectedServices.remove(serviceId);
    } else {
      selectedServices.add(serviceId);
    }
  }

  void selectPlan(int planId) {
    selectedPlanId.value = planId;
  }



  void setDescription(String value) {
    description.value = value;
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
      final errorMessage = e.toString().toLowerCase();
      print(errorMessage);
      if (errorMessage ==
          "please fill the address and phone number fields in your profile first") {
        Get.snackbar(
          'Incomplete Profile',
          '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          duration: Duration(seconds: 6),
          colorText: Colors.white,
          icon: Icon(Icons.warning_amber_outlined, color: Colors.white),
          messageText: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please fill the address and phone number fields in your profile first.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.toNamed(Routes.UPDATEPROFILE),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Update Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    finally {
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
