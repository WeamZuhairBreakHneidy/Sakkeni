import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';

class EditServiceController extends GetxController {
  final description = TextEditingController();
  final RxList<File> newImages = <File>[].obs;
  var networkImages = <String>[].obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final box = GetStorage();
  final tokenService = TokenService();
  var serviceId = 0.obs;
  final picker = ImagePicker();

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

  /// تهيئة البيانات وجلب صور المعرض قبل الدخول
  Future<void> initData(int id, String desc) async {
    serviceId.value = id;
    description.text = desc;
    await fetchGallery(id);
  }

  /// جلب صور المعرض من الخادم
  Future<void> fetchGallery(int serviceId) async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: "${ApiEndpoints.viewServiceProviderServiceGallery}/$serviceId",
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        final data = response.body['data'] ?? [];
        final serviceData = (data as List).firstWhere(
              (s) => s['id'] == serviceId,
          orElse: () => null,
        );

        if (serviceData != null) {
          final galleryData = serviceData['gallery'] ?? [];
          networkImages.value = (galleryData as List)
              .where((g) => g['image_path'] != null)
              .map((g) => ApiEndpoints.baseUrl + g['image_path'] as String)
              .toList();
          print("Fetched network images: ${networkImages.value}");
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch gallery images');
      print("Error fetching gallery: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// اختيار صور جديدة متعددة
  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      newImages.assignAll(picked.map((e) => File(e.path)).toList());
    }
  }

  /// حذف صورة (سواء كانت جديدة أو من المعرض)
  void removeImage(dynamic image) {
    if (image is File) {
      newImages.remove(image);
    } else if (image is String) {
      // بما أن هذا الـ API غير متوفر، نكتفي بحذفها من القائمة المحلية
      // يجب إضافة منطق استدعاء API لحذف الصورة من الخادم هنا
      networkImages.remove(image);
      Get.snackbar('Success', 'Image removed locally. Save changes to update.');
    }
  }

  Future<void> updateService() async {
    isLoading.value = true;
    try {
      final currentUser = user.value;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final fields = {
        'service_provider_service_id': serviceId.value.toString(),
        'description': description.text.trim(),
      };

      final headers = {
        'Authorization': 'Bearer ${currentUser.token}',
        'Accept': 'application/json',
      };

      final response = await ApiService().uploadFiles(
        url: ApiEndpoints.editService,
        files: newImages,
        fileKey: 'service_gallery',
        fields: fields,
        headers: headers,
      );

      final body = response.body;
      if (response.statusCode == 200 && body != null && body is Map<String, dynamic> && body['status'] == true) {
        Get.snackbar('Success', body['message'] ?? 'Service updated');
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.offAllNamed(Routes.MY_SERVICES);
      } else {
        String errorMessage = body != null && body is Map<String, dynamic> ? (body['message'] ?? 'Failed to update service') : 'Failed to update service';
        if (body != null && body is Map<String, dynamic> && body['errors'] != null) {
          body['errors'].forEach((key, value) {
            errorMessage += "\n$key: ${value.join(', ')}";
          });
        }
        Get.snackbar('Error', errorMessage, duration: const Duration(seconds: 5));
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}