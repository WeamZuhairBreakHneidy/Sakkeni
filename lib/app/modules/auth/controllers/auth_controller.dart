import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/data/services/api_endpoints.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  final box = GetStorage();
  final tokenService = TokenService();
  var rememberMe = false.obs;
  var isLoading = false.obs;
  GlobalKey<FormState> loginFormKey=GlobalKey();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    try {
      final response = await ApiService().postApi(
        url: ApiEndpoints.login,
        body: {'email': email, 'password': password},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final body = response.body;

        final status = body['status'];
        final message = body['message'];

        if (status == true) {
          final userData = body['data'];

          final user = UserModel.fromJson(userData);

          await tokenService.saveToken(user.token);
          print(user.token);

          if (rememberMe.value) {
            box.write('rememberMe', true);
          } else {
            box.write('rememberMe', false);
          }

          box.write('user', user.toJson());

          Get.offAllNamed(Routes.HOME);
          Get.snackbar('Success', message ?? 'Login successful');
        } else {
          Get.snackbar('Login Failed', message ?? 'Unknown error');
        }
      } else {
        Get.snackbar('Login Failed', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  UserModel? get currentUser {
    final json = box.read('user');
    if (json != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  Future<void> logout() async {
    await tokenService.removeToken();
    box.erase(); // clears GetStorage
    Get.offAllNamed(Routes.AUTH);
  }

  bool get isLoggedIn => box.hasData('user');
}
