import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/app/data/services/api_endpoints.dart';

import '../../../data/services/api_service.dart';

class FilterController extends GetxController {
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  final RxList<String> countries = ['Country A', 'Country B', 'Country C'].obs;
  final RxList<String> cities = ['City X', 'City Y', 'City Z'].obs;

  var minArea = 0.0.obs;
  var maxArea = 2000.0.obs;

  var minPrice = 0.0.obs;
  var maxPrice = 2000000.0.obs;

  var bathrooms = 0.obs;
  var balconies = 0.obs;

  var amenities = <String>[
    'Pool', 'Gym', 'Parking', 'Garden', 'Elevator', 'Sauna', 'Playground'
  ].obs;

  var selectedAmenities = <String>[].obs;

  var isFurnished = false.obs;

  final pageController = PageController();
  final currentPage = 0.obs;


  void nextPage() {
    if (currentPage.value < 1) {
      currentPage.value++;
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void prevPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
    maxArea.value = 1000;
    minPrice.value = 0;
    maxPrice.value = 2000000;
    bathrooms.value = 0;
    balconies.value = 0;
    selectedAmenities.clear();
    isFurnished.value = false;
  }


  //_________________________________________
  final ApiService apiService = ApiService();

  var countriesData = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCountriesAndCities();
    fetchAmenities();
  }
  final isLoadingCountries = false.obs;
  final isLoadingAmenities = false.obs;

  Future<void> fetchCountriesAndCities() async {
    isLoadingCountries.value = true;

    try {
      final response = await ApiService().getApi(url: ApiEndpoints.viewCountries);

      if (response.statusCode == 200 && response.body != null) {
        final status = response.body['status'];
        final message = response.body['message'];

        if (status == true) {
          final data = response.body['data'] as List<dynamic>;
          countriesData.value = List<Map<String, dynamic>>.from(data);

          // update dropdown
          countries.value = countriesData.map((e) => e['name'].toString()).toList();

          if (countriesData.isNotEmpty) {
            selectedCountry.value = countriesData[0]['name'];
            cities.value = List<String>.from(
              countriesData[0]['cities'].map((c) => c['name'].toString()),
            );
          }


        } else {
          Get.snackbar('Failed', message ?? 'Unable to fetch countries');
        }
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    } finally {
      isLoadingCountries.value = false;
    }
  }

  void onCountrySelected(String countryName) {
    selectedCountry.value = countryName;
    final foundCountry = countriesData.firstWhereOrNull((c) => c['name'] == countryName);
    if (foundCountry != null) {
      cities.value = List<String>.from(
        foundCountry['cities'].map((c) => c['name'].toString()),
      );
      selectedCity.value = '';
    }
  }

  Future<void> fetchAmenities() async {
    isLoadingAmenities.value = true;

    try {
      final response = await ApiService().getApi(url: ApiEndpoints.viewAmenities);

      if (response.statusCode == 200 && response.body != null) {
        final status = response.body['status'];
        final message = response.body['message'];

        if (status == true) {
          amenities.value = List<String>.from(
            response.body['data'].map((e) => e['name'].toString()),
          );


        } else {
          Get.snackbar('Failed', message ?? 'Unable to fetch amenities');
        }
      } else {
        Get.snackbar('Error', 'Something went wrong. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    } finally {
      isLoadingAmenities.value = false;
    }
  }
}
