import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // final nameController = TextEditingController();
  final  firstNameController = TextEditingController();
  final  lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  var isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final box = GetStorage();
  final tokenService = TokenService();

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    // nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }

  Future<void> signup() async {
    // final name = nameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    final email = emailController.text.trim();
    final password = passwordController.text;
    final passwordConfirmation = passwordConfirmationController.text;

    isLoading.value = true;

    try {
      final response = await ApiService().postApi(
        url: ApiEndpoints.signup,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final status = body['status'];
        final message = body['message'];

        if (status == true) {
          final data = body['data'];

          // Add default fields if missing
          data['is_admin'] = 0;
          data['is_super_admin'] = 0;
          data['email_verified_at'] = null;
          data['profile_picture_path'] = null;
          data['address'] = null;
          data['phone_number'] = null;

          // Convert JSON to model
          final user = UserModel.fromJson(data);

          // Save token securely
          await tokenService.saveToken(user.token);

          // Save user data to GetStorage
          box.write('user', user.toJson());

          Get.offAllNamed(Routes.AUTH);
          Get.snackbar('Success', message ?? 'Registration successful');
        } else {
          Get.snackbar('Registration Failed', message ?? 'Unknown error');
        }
      } else {
        Get.snackbar('Error', 'Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
