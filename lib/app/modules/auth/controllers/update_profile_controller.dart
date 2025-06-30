import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/data/services/api_endpoints.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';
import 'profile_controller.dart';

class UpdateProfileController extends GetxController {
  final address = TextEditingController();
  final phone_number = TextEditingController();
  final first_name = TextEditingController();
  final last_name = TextEditingController();

  final Rx<File?> imageFile = Rx<File?>(null);

  final Rx<UserModel?> user = Rx<UserModel?>(null);

  final isLoading = false.obs;
  final box = GetStorage();
  final tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  void loadUserFromStorage() {
    final json = box.read('user');
    if (json != null) {
      user.value = UserModel.fromJson(Map<String, dynamic>.from(json));
      first_name.text = user.value?.firstName ?? '';
      last_name.text = user.value?.lastName ?? '';
      phone_number.text = user.value?.phoneNumber ?? '';
      address.text = user.value?.address ?? '';
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    try {
      final currentUser = user.value;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final fields = {
        'first_name': first_name.text.trim(),
        'last_name': last_name.text.trim(),
        'address': address.text.trim(),
        'phone_number': phone_number.text.trim(),
        'email': currentUser.email,
      };

      final headers = {
        'Authorization': 'Bearer ${currentUser.token}',
        'Accept': 'application/json',
      };

      final Response response;

      if (imageFile.value != null) {
        print('Uploading image: ${imageFile.value!.path}');
        response = await ApiService().uploadSingleImage(
          url: ApiEndpoints.updateProfile,
          fields: fields,
          headers: headers,
          imageFile: File(imageFile.value!.path),
          imageFieldKey: 'profile_picture',
        );
      } else {
        response = await ApiService().postApi(
          url: ApiEndpoints.updateProfile,
          body: fields,
          headers: headers,
        );
      }

      if (response.statusCode == 200 && response.body['status'] == true) {
        imageFile.value = null;

        // استدعاء ProfileController لتحديث بيانات البروفايل
        final profileController = Get.find<ProfileController>();
        await profileController.fetchProfile();

        // الحصول على الصورة المحدثة
        final newProfilePicturePath =
            profileController.userData?.profilePicturePath ??
                currentUser.profilePicturePath;

        // إنشاء نسخة محدثة من المستخدم
        final updatedUser = currentUser.copyWith(
          firstName: first_name.text.trim(),
          lastName: last_name.text.trim(),
          phoneNumber: phone_number.text.trim(),
          address: address.text.trim(),
          profilePicturePath: newProfilePicturePath,
        );

        user.value = updatedUser;
        box.write('user', updatedUser.toJson());

        Get.snackbar('Success', response.body['message'] ?? 'Profile updated');
        Get.offNamed(Routes.PROFILE);
      } else {
        Get.snackbar(
          'Update Failed',
          response.body['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Update error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
