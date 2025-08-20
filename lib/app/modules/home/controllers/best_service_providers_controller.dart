import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../models/best_service_providers_model.dart';

class BestServiceProvidersController extends GetxController {
  final TokenService _tokenService = TokenService();

  final RxBool isLoading = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList<Datum> providers = <Datum>[].obs;
  RxInt currentPage = 1.obs;

  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchBestServiceProviders();
  }

  Future<void> fetchBestServiceProviders() async {
    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.bestServiceProviders}?page=$_currentPage',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body is Map<String, dynamic>) {
          final data = BestServiceProvidersModel.fromJson(response.body);

          if (data.data != null && data.data!.data.isNotEmpty) {
            providers.addAll(data.data!.data);
            _currentPage++;
          } else {
            hasMoreData.value = false;
          }
        } else {
          Get.snackbar('Error', 'Invalid data format from server');
        }
      } else {
        Get.snackbar('Error', 'Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchBestServiceProviders();
    }
  }

  void refreshProviders() {
    providers.clear();
    _currentPage = 1;
    hasMoreData.value = true;
    fetchBestServiceProviders();
  }
}
