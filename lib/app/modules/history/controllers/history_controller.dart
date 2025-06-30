import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test1/app/core/theme/colors.dart';
import '../../../data/models/properties-model.dart';
import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/token_service.dart';

enum HistoryTypeEnum { rent, purchase, offplan }

abstract class HistoryController extends GetxController {
  abstract final HistoryTypeEnum type;

  final isLoading = false.obs;
  final properties = <Datum>[].obs;
  final propertiesModel = Rxn<PropertiesModel>();
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  final tokenService = TokenService();

  String get endpoint {
    switch (type) {
      case HistoryTypeEnum.rent:
        return ApiEndpoints.renthistory;
      case HistoryTypeEnum.purchase:
        return ApiEndpoints.purchasehistory;
      case HistoryTypeEnum.offplan:
        return ApiEndpoints.offplanhistory;
    }
  }

  @override
  void onInit() {
    fetchProperties(); // Load first page
    super.onInit();
  }

  Future<void> fetchProperties({int page = 1, bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService().getApi(
        url: '$endpoint?page=$page',
      );

      // إذا وصل هنا، response.statusCode == 200
      final model = PropertiesModel.fromJson(response.body);
      propertiesModel.value = model;
      final fetchedData = model.data?.data ?? [];

      if (isLoadMore) {
        properties.addAll(fetchedData);
      } else {
        properties.value = fetchedData;
      }

      hasMoreData.value = model.data?.nextPageUrl != null;
      currentPage.value = page;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('permission') || errorMessage.contains('access denied')) {
        Get.defaultDialog(
          backgroundColor: AppColors.white,
          title: "",
          content: Column(
            children: [
              Image.asset(
                'assets/logowithcolor.png',
                width: 100,
                height: 75,
              ),
              SizedBox(height: 10.h),
              Text(
                "You do not have permission to perform this action.\nYou need to be a seller to view this content.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          textConfirm: "OK",
          confirmTextColor: AppColors.white,
          buttonColor: AppColors.primary,
          onConfirm: () {
            Get.back();
          },
          barrierDismissible: false,
        );

    } else {
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (!isLoading.value && hasMoreData.value) {
      fetchProperties(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  Datum? getPropertyById(int id) {
    return properties.firstWhereOrNull((prop) => prop.id == id);
  }
}
