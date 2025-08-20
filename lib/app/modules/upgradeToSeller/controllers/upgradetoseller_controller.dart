import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/core/theme/colors.dart';

import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart'; // ✅ بدل profile بـ auth

class UpgradeToSellerController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  final RxString selectedAccountType = ''.obs;

  void selectAccountType(String type) {
    selectedAccountType.value = type;
  }

  Future<void> upgradeAccount() async {
    if (selectedAccountType.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select an account type.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    int? accountTypeId;
    if (selectedAccountType.value == 'Personal') {
      accountTypeId = 1;
    } else if (selectedAccountType.value == 'Commercial') {
      accountTypeId = 2;
    }

    if (accountTypeId == null) {
      Get.snackbar(
        "Error",
        "Invalid account type selected.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      isLoading.value = false;
      return;
    }

    try {
      final response = await ApiService().postApi(
        url: ApiEndpoints.upgradeAccount,
        body: {'account_type_id': accountTypeId},
      );

      final body = response.body;
      final message = body['message'];

      if (response.statusCode == 200) {
        final status = body['status'];

        if (status == true) {
          // تحديث المستخدم من السيرفر

          GetStorage().write('isSeller', true);

          Get.snackbar(
            'Success',
            message ?? 'Account upgraded successfully',
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
