import 'package:get/get.dart';
import 'package:test1/app/modules/myServices/models/my_services_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/api_endpoints.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart'; //

import '../../../routes/app_pages.dart';
import '../../payment/controllers/sabscruption_controller.dart';

class MyServicesController extends GetxController {
  var myServices = <Datum>[].obs;
  var isLoading = false.obs;

  final sabscruptionController = Get.find<SabscruptionController>();

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
          myServices.value =
              (body['data'] as List).map((e) => Datum.fromJson(e)).toList();
        } else if (body['status'] == false) {}
      }
    } catch (e) {
      if (e ==
          "Your application is approved. Please complete payment to activate your services.") {
        Get.defaultDialog(
          title: "Payment",
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
          barrierDismissible: false, // ما فيك تسكّر الدialog بالضغط برة
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your application is approved. Please complete payment to activate your services.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // لتسكير الـ dialog
                  sabscruptionController.makePayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  'Complete Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      Get.snackbar('', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
