import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'
    as storage; // اسم مستعار لـ GetStorage
import '../../../data/models/profile_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileModel = Rxn<ProfileModel>();

  final tokenService = TokenService();
  final localStorage = storage.GetStorage();

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
        url: ApiEndpoints.profile,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        profileModel.value = ProfileModel.fromJson(response.body);

        if (profileModel.value?.data?.seller != null) {
          localStorage.write('seller', profileModel.value!.data!.seller);
        }

        print(
          'Profile fetched successfully. Is Seller: ${profileModel.value?.data?.seller != null}',
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Data? get userData => profileModel.value?.data; // لا حاجة لتغيير هنا
}
