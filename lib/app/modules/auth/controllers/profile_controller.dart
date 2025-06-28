import 'package:get/get.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileModel = Rxn<ProfileModel>();

  final tokenService = TokenService();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: ApiEndpoints.profile, // تأكد أنه معرف في api_endpoints.dart
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        profileModel.value = ProfileModel.fromJson(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Data? get userData => profileModel.value?.data;
}
