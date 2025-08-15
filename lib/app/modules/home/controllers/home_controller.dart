import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../models/property_home_model.dart' show Data, PropertyListModel;

class RecommendedPropertiesController extends GetxController {
  final TokenService _tokenService = TokenService();
  final RxBool isLoading = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxList<Data> properties = <Data>[].obs;
  RxInt currentPage = 0.obs;

  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProperties();
  }

  Future<void> fetchRecommendedProperties() async {
    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.viewrecommendedProperties}?page=$_currentPage',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = PropertyListModel.fromJson(response.body);
        if (data.data.data.isNotEmpty) {
          properties.addAll(data.data.data);
          _currentPage++;
        } else {
          hasMoreData.value = false;
        }
      } else {
        Get.snackbar('Error', 'Failed to load properties. Status: ${response.statusCode}');
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
      fetchRecommendedProperties();
    }
  }

  void refreshProperties() {
    properties.clear();
    _currentPage = 1;
    hasMoreData.value = true;
    fetchRecommendedProperties();
  }
}