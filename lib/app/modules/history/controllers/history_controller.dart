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
  // **KEY CHANGE HERE: Allow properties to be nullable Datum objects**
  final properties = <Datum?>[].obs;
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
    fetchProperties();
    super.onInit();
  }

  Future<void> fetchProperties({int page = 1, bool isLoadMore = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService().getApi(
        url: '$endpoint?page=$page',
      );

      final model = PropertiesModel.fromJson(response.body);
      propertiesModel.value = model;
      // Ensure fetchedData can handle nulls if the API returns them in the list
      final fetchedData = model.data?.data;

      if (isLoadMore) {
        // Only add non-null items if fetchedData contains nulls, or if you expect it to
        properties.addAll(fetchedData?.whereType<Datum>().toList() ?? []);
      } else {
        // Assign only non-null items
        properties.value = fetchedData?.whereType<Datum>().toList() ?? [];
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logowithcolor.png',
                width: 100.w,
                height: 80.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "You must upgrade to a seller to access this feature.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 25.h),

              SizedBox(
                width: 250.w,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/upgrade-to-seller');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Upgrade to Seller",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              TextButton(
                onPressed: () {
                  Get.back();
                  Get.offAllNamed('/profile');
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );

      }
      else {
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
    return properties.firstWhereOrNull((prop) => prop?.id == id);
  }
}