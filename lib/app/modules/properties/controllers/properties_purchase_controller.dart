import 'package:get/get.dart';

import '../../../data/models/properties-model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class PurchuseController extends GetxController {
  var isLoading = false.obs;
  var properties = <Datum>[].obs;
  var propertiesModel = Rxn<PropertiesModel>();
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  final tokenService = TokenService();

  @override
  void onInit() {
    fetchProperties(); // Load first page by default
    super.onInit();
  }

  Future<void> fetchProperties({int page = 1, bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.purchase}?page=$page',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final model = PropertiesModel.fromJson(response.body);

        propertiesModel.value = model;

        final fetchedData = model.data?.data ?? [];

        if (isLoadMore) {
          properties.addAll(fetchedData);
        } else {
          properties.value = fetchedData;
        }

        // Check if there are more pages
        hasMoreData.value = model.data?.nextPageUrl != null;

        currentPage.value = page;
      } else {
        Get.snackbar('Error', 'Failed to load properties. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchProperties(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  /// Get property by ID
  Datum? getPropertyById(int id) {
    return properties.firstWhereOrNull((prop) => prop.id == id);
  }
}
