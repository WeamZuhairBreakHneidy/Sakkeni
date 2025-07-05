import 'package:get/get.dart';
import '../../../data/models/countries_model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

class CountriesController extends GetxController {
  var isLoading = false.obs;

  var countriesModel = CountreiesModel(status: false, message: "", data: []).obs;

  var selectedCountry = Rxn<Datum>();
  var selectedCity = Rxn<Datum>();

  final tokenService = TokenService();

  @override
  void onInit() {
    fetchCountries();
    super.onInit();
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;

    try {
      final token = await tokenService.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: ApiEndpoints.countries,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        countriesModel.value = CountreiesModel.fromJson(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load countries. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void selectCountry(Datum? country) {
    selectedCountry.value = country;
    selectedCity.value = null; // تفريغ المدينة عند تغيير الدولة
  }

  void selectCity(Datum? city) {
    selectedCity.value = city;
  }
}
