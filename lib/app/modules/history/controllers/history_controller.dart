import 'package:get/get.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

enum HistoryTypeEnum { rent, purchase, offplan }

abstract class HistoryController extends GetxController {
  abstract final HistoryTypeEnum type;

  final isLoading = false.obs;

  // **KEY CHANGE HERE: Allow properties to be nullable Datum objects**
  final properties = <Datum?>[].obs;
  final propertiesModel = Rxn<PropertiesModel>();
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  final tokenService = TokenService();

  String get endpoint {
    switch (type) {
      case HistoryTypeEnum.rent:
        return ApiEndpoints.renthistory;
      case HistoryTypeEnum.purchase:
        return ApiEndpoints.purchasehistory;
      case HistoryTypeEnum.offplan:
        return ApiEndpoints.offplanhistory;
    }
  }

  @override
  void onInit() {
    fetchProperties();
    super.onInit();
  }

  Future<void> fetchProperties({int page = 1, bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService().getApi(url: '$endpoint?page=$page');

      final model = PropertiesModel.fromJson(response.body);
      propertiesModel.value = model;
      final fetchedData = model.data?.data;

      if (isLoadMore) {
        properties.addAll(fetchedData?.whereType<Datum>().toList() ?? []);
      } else {
        properties.value = fetchedData?.whereType<Datum>().toList() ?? [];
      }

      hasMoreData.value = model.data?.nextPageUrl != null;
      currentPage.value = page;
    } catch (e) {
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
    return properties.firstWhereOrNull((prop) => prop?.id == id);
  }
}
