import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class AddServiceController extends GetxController {
  // ✅ تم تغيير المتغير ليحتفظ بمعرف خدمة واحدة
  var selectedServiceId = Rx<int?>(null);
  var expandedCategoryIds = <int>[].obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  var description = ''.obs;
  var isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  void loadUserFromStorage() {
    final json = box.read('user');
    if (json != null) {
      user.value = UserModel.fromJson(Map<String, dynamic>.from(json));
    }
  }

  void toggleCategory(int id) {
    if (expandedCategoryIds.contains(id)) {
      expandedCategoryIds.remove(id);
    } else {
      expandedCategoryIds.add(id);
    }
  }

  // ✅ تم تعديل هذه الدالة للتعامل مع خدمة واحدة
  void toggleService(int serviceId) {
    if (selectedServiceId.value == serviceId) {
      // إذا تم الضغط على نفس الخدمة مرة أخرى، قم بإلغاء تحديدها
      selectedServiceId.value = null;
    } else {
      // قم بتحديد الخدمة الجديدة
      selectedServiceId.value = serviceId;
    }
  }

  void setDescription(String value) {
    description.value = value;
  }

  /// Add a new Service
  Future<void> addService() async {
    // ✅ التحقق من أن الخدمة تم اختيارها
    if (selectedServiceId.value == null) {
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
      final currentUser = user.value;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not logged in');
        isLoading.value = false;
        return;
      }

      final body = {
        // ✅ تم إرسال معرف الخدمة مباشرة
        'service_id': selectedServiceId.value,
        'service_description': description.value.trim(),
      };

      final headers = {
        'Authorization': 'Bearer ${currentUser.token}',
        'Accept': 'application/json',
      };

      final response = await ApiService().postApi(
        url: ApiEndpoints.addService,
        body: body,
        headers: headers,
      );

      final responseBody = response.body;
      final message = responseBody['message'];

      if (response.statusCode == 200 && responseBody['status'] == true) {
        Get.snackbar(
          'Success',
          message ?? 'Service added successfully!',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
        );
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.offAllNamed(Routes.MY_SERVICES);
      } else {
        _handleErrorMessage(message, responseBody);
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
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
      'Failed',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}