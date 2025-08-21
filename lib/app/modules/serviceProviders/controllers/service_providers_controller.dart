import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';

import '../models/service_provider.dart';

class ServiceProvidersController extends GetxController {
  var isLoading = false.obs;
  var providers = <ServiceProvider>[].obs;
  var serviceName = "".obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args['service'] != null) {
      serviceName.value = args['service'];
      fetchProviders(serviceName.value);
    }
  }

  Future<void> fetchProviders(String service) async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: "${ApiEndpoints.viewServiceProviders}?page=1&service=$service",
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          final List<dynamic> data = body['data']['data'];
          providers.value = data
              .map((json) =>
              ServiceProvider.fromJson(json, ApiEndpoints.baseUrl))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching providers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
