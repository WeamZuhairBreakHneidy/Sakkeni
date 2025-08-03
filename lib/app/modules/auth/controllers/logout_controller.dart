import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/app/data/services/api_endpoints.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';

class LogoutController extends GetxController {
  final box = GetStorage();
  final tokenService = TokenService();
  var isLoading = false.obs;

  UserModel? get currentUser {
    final json = box.read('user');
    if (json != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  bool get isLoggedIn => box.hasData('user');

  Future<void> logout() async {
    isLoading.value = true;

    try {
      final response = await ApiService().getApi(url: ApiEndpoints.logout);

      if (response.statusCode == 200) {
        final body = response.body;

        // يمكنك طباعة الرد إن كان بصيغة Map أو JSON
        print("Logout successful: $body");

      } else {
        print('Logout failed with status: ${response.statusCode}');
        Get.snackbar(
          'Logout Failed',
          'Server responded with status code ${response.statusCode}',
        );
      }

    } catch (e) {
      print('Logout API call failed: $e');
      Get.snackbar(
        'Error',
        'Logout API call failed, but you will be logged out locally.',
      );
    } finally {
      await tokenService.removeToken();
      box.erase();
      Get.offAllNamed(Routes.AUTH);
      isLoading.value = false;
    }
  }
}
