import 'package:get/get.dart';
import '../../../data/models/Amentiies_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class AmenitiesController extends GetxController {
  var isLoading = false.obs;

  var amenitiesModel = AmentitiesModel(status: false, message: "", data: []).obs;
  var selectedAmenities = <String>[].obs;
// في AmenitiesController
  List<String> selectedAmenityNames = <String>[].obs; // الأسماء
  List<int> selectedAmenityIds = <int>[].obs;


  // toggle مع تعديل ليحتفظ بتناسق الـ IDs
  void toggleAmenity(String name, int id) {
    if (selectedAmenities.contains(name)) {
      selectedAmenities.remove(name);
      selectedAmenityIds.remove(id);
    } else {
      selectedAmenities.add(name);
      selectedAmenityIds.add(id);
    }
  }


  void updateSelectedAmenityIds() {
    selectedAmenityIds.clear();
    final allAmenities = amenitiesModel.value.data;
    for (var name in selectedAmenityNames) {
      final amenity = allAmenities.firstWhereOrNull((a) => a.name == name);
      if (amenity != null) {
        selectedAmenityIds.add(amenity.id);
      }
    }
  }


  final tokenService = TokenService();

  @override
  void onInit() {
    fetchAmenities();
    super.onInit();
  }

  Future<void> fetchAmenities() async {
    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: ApiEndpoints.viewAmenities, // تأكد من وجود هذا الرابط في `ApiEndpoints`
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        amenitiesModel.value = AmentitiesModel.fromJson(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load amenities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }


}
