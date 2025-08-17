import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';

import '../models/service_category_model.dart';

class ServiceProvidersController extends GetxController {
  var categories = <ServiceCategory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(url: ApiEndpoints.viewServiceCategories);

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          categories.value = (body['data'] as List)
              .map((e) => ServiceCategory.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
