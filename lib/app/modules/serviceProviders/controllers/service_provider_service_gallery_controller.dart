import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import '../models/service_provider_service_gallrey.dart';

class ServiceProviderServiceGalleryController extends GetxController {
  var isLoading = false.obs;
  var gallery = <ServiceProviderServiceGallery>[].obs;
  late int serviceProviderServiceId;

  @override
  void onInit() {
    super.onInit();
    serviceProviderServiceId = Get.arguments as int;
    fetchGallery();
  }

  Future<void> fetchGallery() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: "${ApiEndpoints.viewServiceProviderServiceGallery}/$serviceProviderServiceId",
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        final data = response.body['data'] ?? [];
        final selected = (data as List)
            .cast<Map<String, dynamic>>()
            .firstWhere((s) => s['id'] == serviceProviderServiceId, orElse: () => {});
        final galleryData = selected['gallery'] ?? [];
        gallery.value = (galleryData as List)
            .map((g) => ServiceProviderServiceGallery.fromJson(g, ApiEndpoints.baseUrl))
            .toList();
      }
    } catch (e) {
      print("Error fetching gallery: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
