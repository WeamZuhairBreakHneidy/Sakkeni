import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import '../models/service_provider_details.dart';

class ServiceProviderDetailsController extends GetxController {
  var isLoading = false.obs;
  var isRequesting = false.obs;
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
          providerDetails.value = ServiceProviderDetails.fromJson(
            body['data'],
            ApiEndpoints.baseUrl,
          );
        }
      }
    } catch (e) {
      print("Error fetching provider details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestService({
    required int serviceProviderId,
    required int serviceId,
    required String jobDescription,
  }) async {
    isRequesting.value = true;
    try {
      final response = await ApiService().postApi(
        url: ApiEndpoints.requestService,
        body: {
          "service_provider_id": serviceProviderId,
          "service_id": serviceId,
          "job_description": jobDescription,
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final message = body['message'] ?? "Request completed.";

        if (body['status'] == true) {
          Get.snackbar("Success", message, snackPosition: SnackPosition.BOTTOM);

        } else {
          Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Error", "Unexpected server response",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isRequesting.value = false;
    }
  }
}
