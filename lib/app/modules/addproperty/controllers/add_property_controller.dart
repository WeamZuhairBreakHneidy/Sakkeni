import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddpropertyController extends GetxController {
  // Sell Type & Property Type
  var selectedSellTypeIndex = 0.obs;
  var selectedPropertyTypeIndex = 0.obs;

  // ---------------- Apartment ----------------
  final priceController = TextEditingController();
  final leasePeriodController = TextEditingController();
  final paymentPalController = TextEditingController();
  final furnishingController = TextEditingController();

  final floorNumberRentController = TextEditingController();
  final buildingNumberRentController = TextEditingController();
  final apartmentNumberRentController = TextEditingController();

  final floorNumberSaleController = TextEditingController();
  final buildingNumberSaleController = TextEditingController();
  final apartmentNumberSaleController = TextEditingController();

  final deliveryDateController = TextEditingController();
  final firstPayController = TextEditingController();
  final overallPaymentController = TextEditingController();
  final payPlanController = TextEditingController();
  final floorNumberOffPlanController = TextEditingController();
  final buildingNumberOffPlanController = TextEditingController();
  final apartmentNumberOffPlanController = TextEditingController();

  // ---------------- Villa ----------------
  final villaPaymentpalRentController = TextEditingController();
  final villaFurnishingRentController = TextEditingController();
  final villaBedroomsRentController = TextEditingController();
  final villaFloorNumberRentController = TextEditingController();

  final villaYardSaleController = TextEditingController();
  final villaGarageSaleController = TextEditingController();
  final villaBedroomSaleController = TextEditingController();

  final villaBedroomOffplanController = TextEditingController();

  // ---------------- Common ----------------
  final location = TextEditingController();
  final selectedDirections = <String>[].obs;

  void toggleDirection(String direction) {
    selectedDirections.contains(direction)
        ? selectedDirections.remove(direction)
        : selectedDirections.add(direction);
  }

  final count = 0.obs;

  void increment() => count.value++;

  // ---------------- Dispose ----------------
  @override
  void onClose() {
    // Apartment
    priceController.dispose();
    leasePeriodController.dispose();
    paymentPalController.dispose();
    furnishingController.dispose();

    floorNumberRentController.dispose();
    buildingNumberRentController.dispose();
    apartmentNumberRentController.dispose();

    floorNumberSaleController.dispose();
    buildingNumberSaleController.dispose();
    apartmentNumberSaleController.dispose();

    deliveryDateController.dispose();
    firstPayController.dispose();
    overallPaymentController.dispose();
    payPlanController.dispose();

    floorNumberOffPlanController.dispose();
    buildingNumberOffPlanController.dispose();
    apartmentNumberOffPlanController.dispose();

    // Villa
    villaPaymentpalRentController.dispose();
    villaFurnishingRentController.dispose();
    villaBedroomsRentController.dispose();
    villaFloorNumberRentController.dispose();

    villaYardSaleController.dispose();
    villaGarageSaleController.dispose();
    villaBedroomSaleController.dispose();

    villaBedroomOffplanController.dispose();

    // Common
    location.dispose();

    super.onClose();
  }

}
