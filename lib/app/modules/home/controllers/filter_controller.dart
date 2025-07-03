import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/app/data/services/api_endpoints.dart';
import '../../../data/enums/property_type_enum.dart';
import '../../../data/services/api_service.dart';
  // <-- Import the enum here

class FilterController extends GetxController {
  // Property type
  var selectedPropertyType = PropertyTypeEnum.rent.obs;

  // country/city
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  final RxList<String> countries = <String>[].obs;
  final RxList<String> cities = <String>[].obs;

  // area and price
  var minArea = 0.0.obs;
  var maxArea = 2000.0.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 2000000.0.obs;

  // off-plan extras
  var minFirstPay = 0.0.obs;
  var maxFirstPay = 0.0.obs;
  var deliveryDate = ''.obs;

  // bathrooms/balconies
  var bathrooms = 0.obs;
  var balconies = 0.obs;

  // amenities
  var amenities = <String>[].obs;
  var selectedAmenities = <String>[].obs;

  var isFurnished = false.obs;

  // pageview
  final pageController = PageController();
  final currentPage = 0.obs;

  // country/city data
  var countriesData = <Map<String, dynamic>>[].obs;
  //lease period for rent
  var leasePeriodLength = 12.obs; // default to 12
  var leasePeriodUnit = "Month".obs; // default unit

  // loading
  final isLoadingCountries = false.obs;
  final isLoadingAmenities = false.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchCountriesAndCities();
    fetchAmenities();
  }

  void nextPage() {
    if (currentPage.value < 1) {
      currentPage.value++;
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void prevPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void addAmenity(String amenity) {
    if (!amenities.contains(amenity)) {
      amenities.add(amenity);
    }
  }

  void clearFilters() {
    selectedCountry.value = '';
    selectedCity.value = '';
    minArea.value = 0;
    maxArea.value = 2000;
    minPrice.value = 0;
    maxPrice.value = 2000000;
    bathrooms.value = 0;
    balconies.value = 0;
    selectedAmenities.clear();
    isFurnished.value = false;
    minFirstPay.value = 0;
    maxFirstPay.value = 0;
    deliveryDate.value = '';
    leasePeriodLength.value = 12;
    leasePeriodUnit.value = "Month";
  }

  Future<void> fetchCountriesAndCities() async {
    isLoadingCountries.value = true;

    try {
      final response = await apiService.getApi(url: ApiEndpoints.viewCountries);

      if (response.statusCode == 200 && response.body != null) {
        if (response.body['status'] == true) {
          final data = response.body['data'] as List<dynamic>;
          countriesData.value = List<Map<String, dynamic>>.from(data);

          countries.value = countriesData.map((e) => e['name'].toString()).toList();

          if (countriesData.isNotEmpty) {
            selectedCountry.value = countriesData[0]['name'];
            cities.value = List<String>.from(
              countriesData[0]['cities'].map((c) => c['name'].toString()),
            );
          }
        } else {
          Get.snackbar('Failed', response.body['message'] ?? 'Unable to fetch countries');
        }
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingCountries.value = false;
    }
  }

  void onCountrySelected(String countryName) {
    selectedCountry.value = countryName;
    final found = countriesData.firstWhereOrNull((c) => c['name'] == countryName);
    if (found != null) {
      cities.value = List<String>.from(found['cities'].map((c) => c['name'].toString()));
      selectedCity.value = '';
    }
  }

  Future<void> fetchAmenities() async {
    isLoadingAmenities.value = true;

    try {
      final response = await apiService.getApi(url: ApiEndpoints.viewAmenities);

      if (response.statusCode == 200 && response.body != null) {
        if (response.body['status'] == true) {
          amenities.value = List<String>.from(
            response.body['data'].map((e) => e['name'].toString()),
          );
        } else {
          Get.snackbar('Failed', response.body['message'] ?? 'Unable to fetch amenities');
        }
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAmenities.value = false;
    }
  }

  /// Helper for ID
  int getSelectedCountryId() {
    final found = countriesData.firstWhereOrNull((c) => c['name'] == selectedCountry.value);
    return found?['id'] ?? 0;
  }

  int getSelectedCityId() {
    final foundCountry = countriesData.firstWhereOrNull((c) => c['name'] == selectedCountry.value);
    if (foundCountry != null) {
      final city = (foundCountry['cities'] as List<dynamic>).firstWhereOrNull(
              (c) => c['name'] == selectedCity.value);
      return city?['id'] ?? 0;
    }
    return 0;
  }

  int getAmenityIdByName(String name) {
    // if your backend returns amenity ids, you could store them in a Map
    // for now, assume name == id 1:1 mapping for demonstration
    return amenities.indexOf(name) + 1;
  }

  /// Generate filter request body
  Map<String, dynamic> buildFilterBody() {
    final Map<String, dynamic> body = {
      'country_id': getSelectedCountryId(),
      'city_id': getSelectedCityId(),
      'min_area': minArea.value.toInt(),
      'max_area': maxArea.value.toInt(),
      if (bathrooms.value != 0) 'bathrooms': bathrooms.value,
      if (balconies.value != 0) 'balconies': balconies.value,
      'amenity_ids': selectedAmenities.map((e) => getAmenityIdByName(e)).toList(),
      'min_price': minPrice.value.toInt(),
      'max_price': maxPrice.value.toInt(),
      'is_furnished': isFurnished.value ? 1 : 0,
    };

    if (selectedPropertyType.value == PropertyTypeEnum.offplan) {
      body.addAll({
        'min_first_pay': minFirstPay.value.toInt(),
        'max_first_pay': maxFirstPay.value.toInt(),
        'delivery_date': deliveryDate.value,
      });
    }

    if (selectedPropertyType.value == PropertyTypeEnum.rent) {
      body.addAll({
        'lease_period_length': leasePeriodLength.value,
        'lease_period_unit': leasePeriodUnit.value,
      });
    }

    return body;
  }
}
