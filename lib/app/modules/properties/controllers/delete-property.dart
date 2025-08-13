import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
class DeletePropertyController extends GetxController {
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

  Future<void> deleteProperty(int propertyId) async {
    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().deleteApi(
        url: '${ApiEndpoints.deleteProperty}/$propertyId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Property deleted successfully.');
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete property. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
