import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
