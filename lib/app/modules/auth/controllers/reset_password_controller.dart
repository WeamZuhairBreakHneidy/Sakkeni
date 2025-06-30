import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/app/data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';
class ResetPasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final tokenService = TokenService();
  Future<void> resetPassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    isLoading.value = true;
    try {
      final token = await tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found');
        return;
      }

      final body = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'newPassword_confirmation': confirmPassword,
      };

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      final response = await ApiService().postApi(
        url: ApiEndpoints.resetpassword,
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200 && response.body['status'] == true) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Password updated successfully',
        );
        Get.toNamed(Routes.AUTH);
      } else {
        Get.snackbar(
          'Failed',
          response.body['message'] ?? 'Failed to update password',
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
