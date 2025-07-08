import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/app/data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/user_model.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final tokenService = TokenService();
  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    UserModel? userModel;
    @override
    void onInit() {
      super.onInit();

      // إما تمرير userModel من Get.arguments أو تحميله من مكان تخزين
      userModel = Get.arguments?['userModel'];

      // إذا فيه إيميل موجود، عبّ الحقل تلقائيًا
      emailController.text = userModel?.email ?? '';
    }

    isLoading.value = true;
    try {
      final token = await tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found');
        return;
      }

      final body = {
        'email': email,
      };

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      final response = await ApiService().postApi(
        url: ApiEndpoints.forgetpassword,
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
