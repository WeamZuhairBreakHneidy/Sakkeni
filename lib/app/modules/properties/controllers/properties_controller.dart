import 'package:get/get.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

enum PropertyTypeEnum { rent, purchase, offplan }

abstract class BasePropertiesController extends GetxController {
  abstract final PropertyTypeEnum type;

  final isLoading = false.obs;
  final properties = <Datum>[].obs;
  final propertiesModel = Rxn<PropertiesModel>();
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  final tokenService = TokenService();

  String get endpoint {
    switch (type) {
      case PropertyTypeEnum.rent:
        return ApiEndpoints.rent;
      case PropertyTypeEnum.purchase:
        return ApiEndpoints.purchase;
      case PropertyTypeEnum.offplan:
        return ApiEndpoints.offplan;
    }
  }

  @override
  void onInit() {
    fetchProperties(); // Load first page
    super.onInit();
  }

  Future<void> fetchProperties({int page = 1, bool isLoadMore = false, bool force = false}) async {
    if (!force && (isLoading.value || (!hasMoreData.value && isLoadMore))) return;

    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '$endpoint?page=$page',
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

        hasMoreData.value = model.data?.nextPageUrl != null;
        currentPage.value = page;
      } else {
        Get.snackbar('Error', 'Failed to load properties. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  var isFiltered = false.obs;

  Future<void> fetchFilteredProperties({
    required int page,
    required Map<String, dynamic> filterBody,
  }) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().postApi(
        url: '$endpoint?page=$page',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: filterBody,
      );

      if (response.statusCode == 200) {
        final model = PropertiesModel.fromJson(response.body);
        propertiesModel.value = model;
        final fetchedData = model.data?.data ?? [];

        properties.value = fetchedData;

        hasMoreData.value = model.data?.nextPageUrl != null;
        currentPage.value = page;
        isFiltered.value = true;  // set the flag
      } else {
        Get.snackbar('Error', 'Failed to load filtered properties');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchProperties(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  Datum? getPropertyById(int id) {
    return properties.firstWhereOrNull((prop) => prop.id == id);
  }
}
