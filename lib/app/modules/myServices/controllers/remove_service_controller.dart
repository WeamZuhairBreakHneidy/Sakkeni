import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class RemoveServiceController extends GetxController {
  final isLoading = false.obs;
  final TokenService _tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> removeService(int serviceId) async {
    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return false;
      }

      final response = await ApiService().deleteApi(
        url: '${ApiEndpoints.removeService}/$serviceId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Service removed successfully.');
        return true; // ✅ نجاح
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove service. Status: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
