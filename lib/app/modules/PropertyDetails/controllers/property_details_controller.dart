import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../models/property_details_model.dart';

class PropertyDetailsController extends GetxController {
  final isLoading = false.obs;
  final Rx<PropertyDetail?> propertyDetails = Rx<PropertyDetail?>(null);
  final TokenService _tokenService = TokenService();
  final RxInt currentImageIndex = 0.obs;

  @override
  void onInit() {
    pageController = PageController(viewportFraction: 0.8);
    startAutoSlide();
    super.onInit();
    final dynamic propertyIdArgument = Get.arguments;
    if (propertyIdArgument != null) {
      int? propertyId;
      if (propertyIdArgument is int) {
        propertyId = propertyIdArgument;
      } else if (propertyIdArgument is String) {
        propertyId = int.tryParse(propertyIdArgument);
      }

      if (propertyId != null) {
        fetchPropertyDetails(propertyId);
      } else {
        Get.snackbar('Error', 'Invalid property ID received.');
      }
    }
  }

  late PageController pageController;
  Timer? autoSlideTimer;


  void startAutoSlide() {
    autoSlideTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      final images = propertyDetails.value?.data?.images;
      if (images == null || images.isEmpty) return;

      int nextPage = (currentImageIndex.value + 1) % images.length;

      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    autoSlideTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }


  Future<void> fetchPropertyDetails(int propertyId) async {
    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.viewPropertyDetails}/$propertyId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        propertyDetails.value = PropertyDetail.fromJson(response.body);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load property details. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }
}