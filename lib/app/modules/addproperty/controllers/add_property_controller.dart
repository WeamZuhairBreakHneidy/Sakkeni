import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../controllers/amenties_controller.dart';

class AddpropertyController extends GetxController {
  final RxList<File> selectedImages = <File>[].obs;

  final amenitiesController = Get.find<AmenitiesController>();

  // ---- Selection States ----
  var selectedSellTypeIndex = 0.obs; // Rent, Sale, Off Plan
  var selectedPropertyTypeIndex = 0.obs; // Apartment, Villa, Office
  final selectedCountryId = Rxn<int>();
  final selectedCityId = Rxn<int>();

  // ---- Common Fields ----
  final location = TextEditingController();
  final selectedDirections = <String>[].obs;
  final selectedLocation = Rxn<LatLng>();
  GoogleMapController? mapController;

  void toggleDirection(String direction) {
    selectedDirections.contains(direction)
        ? selectedDirections.remove(direction)
        : selectedDirections.add(direction);
  }

  void updateLocation(LatLng latLng) {
    selectedLocation.value = latLng;
    location.text = "${latLng.latitude}, ${latLng.longitude}";
    animateToLocation(latLng);
  }

  void animateToLocation(LatLng latLng) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
    if (selectedLocation.value != null) {
      animateToLocation(selectedLocation.value!);
    }
  }

  // ---- Apartment Fields ----
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final balconiesController = TextEditingController();
  final bathroomsController = TextEditingController();
  final leasePeriodValueController = TextEditingController();
  final leasePeriodUnitController = TextEditingController();
  final leasePeriodController = TextEditingController();
  final paymentPalController = TextEditingController();
  final furnishingController = TextEditingController();

  final floorNumberRentController = TextEditingController();
  final buildingNumberRentController = TextEditingController();
  final apartmentNumberRentController = TextEditingController();
  final bedroomsController = TextEditingController();

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

  // ---- Villa Fields ----
  final villaPaymentpalRentController = TextEditingController();
  final villaFurnishingRentController = TextEditingController();
  final villaBedroomsRentController = TextEditingController();
  final villaFloorNumberRentController = TextEditingController();

  final villaYardSaleController = TextEditingController();
  final villaGarageSaleController = TextEditingController();
  final villaBedroomSaleController = TextEditingController();

  final villaBedroomOffplanController = TextEditingController();

  // ---- Office Fields ----
  final officeAreaRentController = TextEditingController();
  final officeFurnishedSaleController = TextEditingController();
  final officeMaintenanceOffplanController = TextEditingController();

  // ---- Example Counter ----
  final count = 0.obs;

  void increment() => count.value++;

  // ---- Dispose All Controllers ----
  @override
  void onClose() {
    // Common
    location.dispose();

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

    // Office
    officeAreaRentController.dispose();
    officeFurnishedSaleController.dispose();
    officeMaintenanceOffplanController.dispose();

    super.onClose();
  }

  // Properties to be sent in the API request
  final countryId = 1.obs; // You need to get this from the CountriesController
  final cityId = 1.obs; // You need to get this from the CountriesController
  final additionalInfo = TextEditingController();
  final area = TextEditingController();
  final bathrooms = TextEditingController();
  final balconies = TextEditingController();
  final ownershipTypeId = 1.obs; // This might need to be dynamic as well
  final exposureList =
      <int>[].obs; // This needs to be populated from selectedDirections

  // Helper to convert selectedDirections (Strings) to exposureList (int)
  void updateExposureList() {
    exposureList.clear();

    for (var direction in selectedDirections) {
      final d = direction.toLowerCase();

      if (d == 'north') exposureList.add(1);
      if (d == 'south') exposureList.add(2);
      if (d == 'east') exposureList.add(3);
      if (d == 'west') exposureList.add(4);
      if (d == 'northeast') exposureList.add(5);
      if (d == 'northwest') exposureList.add(6);
      if (d == 'southeast') exposureList.add(7);
      if (d == 'southwest') exposureList.add(8);
    }
  }

  // Helper to convert selected amenity names to amenity IDs
  void updateAmenitiesList() {
    amenitiesController.selectedAmenities.clear();
    final allAmenities = amenitiesController.amenitiesModel.value.data;
    // Assuming amenitiesController.selectedAmenities holds selected amenity names
    for (var selectedAmenityName in amenitiesController.selectedAmenities) {
      final amenity = allAmenities.firstWhereOrNull(
        (datum) => datum.name == selectedAmenityName,
      );
      if (amenity != null) {
        amenitiesController.selectedAmenities.add(amenity.id as String);
      }
    }
  }

  Future<void> submitProperty() async {
    print(priceController.text);
    print(priceController.text);
    print(priceController.text);
    final api = ApiService();
    final sellType =
        selectedSellTypeIndex.value; // 0: Rent, 1: Sale, 2: Off Plan
    final propertyType =
        selectedPropertyTypeIndex.value; // 0: Apartment, 1: Villa, 2: Office

    updateExposureList(); // Call this here!
    updateAmenitiesList(); // Call this here!

    int sellTypeValue;
    if (sellType == 0) {
      sellTypeValue = 2;
    } else if (sellType == 1) {
      sellTypeValue = 1;
    } else {
      sellTypeValue = 3;
    }
    // Map property type to API values
    int propertyTypeId;
    int? residentialPropertyTypeId;
    int? commercialPropertyTypeId;

    if (propertyType == 0) {
      // Apartment
      propertyTypeId = 1;
      residentialPropertyTypeId = 1;
    } else if (propertyType == 1) {
      // Villa
      propertyTypeId = 1;
      residentialPropertyTypeId = 2;
    } else {
      // Office
      propertyTypeId = 2;
      commercialPropertyTypeId = 1;
    }

    dynamic safeParseInt(TextEditingController controller) {
      return int.tryParse(controller.text);
    }

    dynamic safeParseDouble(TextEditingController controller) {
      return double.tryParse(controller.text);
    }

    final Map<String, dynamic> baseBody = {
      'country_id': selectedCountryId.value.toString(),
      'city_id': selectedCityId.value.toString(),
      'latitude': selectedLocation.value?.latitude.toString() ?? '',
      'longitude': selectedLocation.value?.longitude.toString() ?? '',
      'additional_info': additionalInfo.text,
      'area': area.text,
      'bathrooms': bathrooms.text,
      'balconies': balconies.text,
      'ownership_type_id': ownershipTypeId.value.toString(),
      'property_type_id': propertyTypeId.toString(),
      'sell_type_id': sellTypeValue.toString(),
    };
    // Add residential or commercial property type based on selection
    if (residentialPropertyTypeId != null) {
      baseBody['residential_property_type_id'] =
          residentialPropertyTypeId.toString();
    }
    if (commercialPropertyTypeId != null) {
      baseBody['commercial_property_type_id'] =
          commercialPropertyTypeId.toString();
    }

    // Correctly add exposureList and amenitiesList for multipart form data
    // Add each exposure element with an indexed key
    for (var i = 0; i < exposureList.length; i++) {
      baseBody['exposure[$i]'] = exposureList[i].toString();
    }
    if (amenitiesController.selectedAmenityIds.isEmpty) {
      baseBody['amenities[0]'] = ''; // إرسال قيمة فارغة تضمن وجود المفتاح
    } else {
      for (var i = 0; i < amenitiesController.selectedAmenityIds.length; i++) {
        baseBody['amenities[$i]'] =
            amenitiesController.selectedAmenityIds[i].toString();
      }
    }

    print("Selected Directions: $selectedDirections");
    print("Exposure List: $exposureList");
    print(
      "Amenities List (IDs): ${amenitiesController.selectedAmenities}",
    ); // Added for debugging

    // Add specific fields based on property and sell type
    final body = {
      ...baseBody,
    }; // Create 'body' from 'baseBody' after adding exposure and amenities

    if (propertyType == 0||propertyType==1) {
      // Apartment
      if (sellType == 0||sellType==1) {
        // Rent
        body.addAll({
          'price': priceController.text,
          'area': safeParseInt(areaController),
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnitController.text,
          'bathrooms': bathroomsController.text,
          'bedrooms': bedroomsController.text,
          'balconies': balconiesController.text,
          'is_furnished': safeParseInt(furnishingController),
          'floor': safeParseInt(floorNumberRentController),
          'building_number': safeParseInt(buildingNumberRentController),
          'apartment_number': safeParseInt(apartmentNumberRentController),
        });
      }
      else if (sellType == 1) {
        // Sale
        body.addAll({
          'price': priceController.text,
          'area': safeParseInt(areaController),
          'bathrooms': bathroomsController.text,
          'bedrooms': bedroomsController.text,
          'balconies': balconiesController.text,
          'is_furnished': safeParseInt(furnishingController),
          'floor': safeParseInt(floorNumberRentController),
          'building_number': safeParseInt(buildingNumberRentController),
          'apartment_number': safeParseInt(apartmentNumberRentController),
        });
      }
      else if (sellType == 2) {
        // Off Plan
        body.addAll({
          'delivery_date': deliveryDateController.text, // Assuming string
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          'pay_plan': payPlanController.text, // Assuming string
          'floor': safeParseInt(floorNumberOffPlanController),
          'building_number': safeParseInt(buildingNumberOffPlanController),
          'apartment_number': safeParseInt(apartmentNumberOffPlanController),
        });
      }
    }
    else if (propertyType == 1) {
      // Villa
      if (sellType == 0) {
        // Rent
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period': leasePeriodController.text, // Assuming string
          'payment_plan': villaPaymentpalRentController.text, // Assuming string
          'furnishing': villaFurnishingRentController.text, // Assuming string
          'bedrooms': safeParseInt(villaBedroomsRentController),
          'floor': safeParseInt(villaFloorNumberRentController),
        });
      } else if (sellType == 1) {
        // Sale
        body.addAll({
          'price': safeParseDouble(priceController),
          'yard_area': safeParseDouble(villaYardSaleController),
          'garage': safeParseInt(villaGarageSaleController),
          'bedrooms': safeParseInt(villaBedroomSaleController),
        });
      } else if (sellType == 2) {
        // Off Plan
        body.addAll({
          'delivery_date': deliveryDateController.text, // Assuming string
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          'pay_plan': payPlanController.text, // Assuming string
          'bedrooms': safeParseInt(villaBedroomOffplanController),
          'floor': safeParseInt(floorNumberOffPlanController),
        });
      }
    } else if (propertyType == 2) {
      // Office
      if (sellType == 0) {
        // Rent
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period': leasePeriodController.text, // Assuming string
          'payment_plan': paymentPalController.text, // Assuming string
          'furnishing': furnishingController.text, // Assuming string
          'floor': safeParseInt(floorNumberRentController),
          'building_number': safeParseInt(buildingNumberRentController),
          'area': safeParseDouble(officeAreaRentController),
        });
      } else if (sellType == 1) {
        // Sale
        body.addAll({
          'price': safeParseDouble(priceController),
          'furnishing': officeFurnishedSaleController.text, // Assuming string
          'floor': safeParseInt(floorNumberSaleController),
          'building_number': safeParseInt(buildingNumberSaleController),
          'apartment_number': safeParseInt(apartmentNumberSaleController),
        });
      } else if (sellType == 2) {
        // Off Plan
        body.addAll({
          'delivery_date': deliveryDateController.text,
          // Assuming string
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          'pay_plan': payPlanController.text,
          // Assuming string
          'maintenance': officeMaintenanceOffplanController.text,
          // Assuming string
          'floor': safeParseInt(floorNumberSaleController),
          'building_number': safeParseInt(buildingNumberSaleController),
          'apartment_number': safeParseInt(apartmentNumberSaleController),
        });
      }
    }

    try {
      String endpoint;
      endpoint = ApiEndpoints.addProperty;
      if (selectedImages.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select at least 3 images for the property.',
        );
        return; // Stop submission if no images
      }

      final response = await api.uploadFiles(
        url: endpoint,
        files: selectedImages.toList(), // List of selected files
        fileKey: 'images', // Backend field name for images
        fields:
            body, // Use 'body' which now includes correctly formatted exposure and amenities
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Property added successfully',
        );
        // Additional actions on success
      } else {
        Get.snackbar(
          'Error',
          response.body['message'] ?? 'Failed to add property',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }
}
