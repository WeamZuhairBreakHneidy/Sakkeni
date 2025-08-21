import 'package:get/get.dart';
import 'package:test1/app/modules/myServices/models/my_services_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';

class MyServicesController extends GetxController {
  var myServices = <Datum>[].obs; // <-- change to Datum list
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyServices();
  }

  Future<void> fetchMyServices() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(url: ApiEndpoints.myServices);

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['status'] == true) {
          myServices.value = (body['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
