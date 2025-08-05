// lib/app/modules/home/controllers/home_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';
import '../../../routes/app_pages.dart';
import '../../PropertyDetails/models/property_details_model.dart';
import '../../../data/models/properties-model.dart'; // تأكد من استيراد نموذج القائمة الصحيح
import '../models/property_home_model.dart'; // تم إضافة استيراد النموذج الجديد

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  // قائمة لتخزين جميع العقارات
  final RxList<Datum> allProperties = <Datum>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMoreData = true.obs;
  int _currentPage = 1;

  final TokenService _tokenService = TokenService();

  // المتغيرات الخاصة بعرض تفاصيل العقار الفردي وشريط الصور
  final Rx<PropertyDetail?> propertyDetails = Rx<PropertyDetail?>(null);
  final RxInt currentImageIndex = 0.obs;
  late PageController pageController;
  Timer? autoSlideTimer;

  @override
  void onInit() {
    super.onInit();
    // إعداد PageController لعرض الشرائح
    pageController = PageController(viewportFraction: 0.8);
    // جلب البيانات الأولية لقائمة العقارات
    fetchRecommendedProperties();
    // جلب تفاصيل عقار واحد (مثال: العقار الأول) لبدء عرض الشرائح
    // يمكنك استدعاء هذه الدالة عندما يختار المستخدم عقارًا معينًا
    // fetchPropertyDetails(1);
  }

  // دالة لبدء التمرير التلقائي للصور
  void startAutoSlide() {
    // نتحقق أولاً مما إذا كان لدينا تفاصيل عقار وصور
    if (propertyDetails.value?.data?.images == null ||
        propertyDetails.value!.data!.images.isEmpty) {
      return;
    }

    autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final images = propertyDetails.value!.data!.images;
      int nextPage = (currentImageIndex.value + 1) % images.length;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
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

  // دالة لجلب العقارات الموصى بها مع دعم التحميل اللانهائي
  Future<void> fetchRecommendedProperties() async {
    if (!hasMoreData.value || isLoading.value) {
      return;
    }

    isLoading.value = true;
    try {
      final token = await _tokenService.token;
      if (token == null || token.isEmpty) {
        Get.snackbar('Unauthorized', 'User token not found.');
        return;
      }

      final response = await ApiService().getApi(
        url: '${ApiEndpoints.viewPropertyDetails}/4',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final propertiesResponse = PropertiesListModel.fromJson(response.body);
        if (propertiesResponse.data != null &&
            propertiesResponse.data!.isNotEmpty) {
          allProperties.addAll(propertiesResponse.data!);
          _currentPage++;
        } else {
          hasMoreData.value = false;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load properties. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // دالة لتحميل الصفحة التالية
  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchRecommendedProperties();
    }
  }

  // دالة لجلب تفاصيل عقار معين
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
        // Start auto slide after fetching property details
        startAutoSlide();
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
}
