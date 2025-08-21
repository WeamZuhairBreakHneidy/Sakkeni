import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import '../models/service_provider_details.dart';

class ServiceProviderDetailsController extends GetxController {
  var isLoading = false.obs;
  var providerDetails = Rxn<ServiceProviderDetails>();

  Future<void> fetchProviderDetails(int serviceProviderId) async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: "${ApiEndpoints.viewServiceProvidersDetails}/$serviceProviderId",
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          providerDetails.value = ServiceProviderDetails.fromJson(body['data'], ApiEndpoints.baseUrl);
        }
      }
    } catch (e) {
      print("Error fetching provider details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
