import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/services/api_endpoints.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/amenties_controller.dart';

class AddpropertyController extends GetxController {
  final RxList<File> selectedImages = <File>[].obs;
  final Rx<File?> selectedVideo = Rx<File?>(null);

  var isLoading = false.obs;
  final TextEditingController payPlanDurationValue0Controller =
  TextEditingController();
  final TextEditingController payPlanDurationUnit0Controller =
  TextEditingController();
  final TextEditingController payPlanPercentage0Controller =
  TextEditingController();
  final TextEditingController payPlanDurationValue1Controller =
  TextEditingController();
  final TextEditingController payPlanDurationUnit1Controller =
  TextEditingController();
  final TextEditingController payPlanPercentage1Controller =
  TextEditingController();
  final TextEditingController payPlanDurationValue2Controller =
  TextEditingController();
  final TextEditingController payPlanDurationUnit2Controller =
  TextEditingController();
  final TextEditingController payPlanPercentage2Controller =
  TextEditingController();

  final amenitiesController = Get.find<AmenitiesController>();
  RxString leasePeriodUnit = ''.obs;
  RxString furnishing = ''.obs;

  var selectedSellTypeIndex = 0.obs;
  var selectedPropertyTypeIndex = 0.obs;
  final selectedCountryId = Rxn<int>();
  final selectedCityId = Rxn<int>();

  // ---- Common Location Fields ----
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

  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final balconiesController = TextEditingController();
  final bathroomsController = TextEditingController();
  final leasePeriodValueController = TextEditingController();
  final bedroomsController = TextEditingController();
  final additionalInfo = TextEditingController();

  final floorNumberController =
  TextEditingController(); // For Apartment/Office/Villa
  final buildingNumberController =
  TextEditingController(); // For Apartment/Office
  final apartmentNumberController =
  TextEditingController(); // For Apartment/Office

  // For Off Plan specific fields (delivery, first payment, overall payment)
  final deliveryDateController = TextEditingController();
  final firstPayController = TextEditingController();
  final overallPaymentController = TextEditingController();

  // For Villa specific fields (yard, garage, maintenance)
  final yardAreaController = TextEditingController();
  final garageController = TextEditingController();
  final maintenanceController =
  TextEditingController(); // General maintenance field, primarily for Offices

  // --- Removed all specific controllers like floorNumberRentController, villaBedroomSaleController etc. ---

  // For Payment Plan PageView
  late PageController paymentPageController;
  final RxInt currentPaymentPageIndex = 0.obs;

  final count = 0.obs; // Example counter

  void increment() => count.value++;

  // ---- Dispose All Controllers ----
  @override
  void onClose() {
    // Consolidated fields
    location.dispose();
    priceController.dispose();
    areaController.dispose();
    balconiesController.dispose();
    bathroomsController.dispose();
    leasePeriodValueController.dispose();
    bedroomsController.dispose();
    additionalInfo.dispose();
    floorNumberController.dispose();
    buildingNumberController.dispose();
    apartmentNumberController.dispose();
    deliveryDateController.dispose();
    firstPayController.dispose();
    overallPaymentController.dispose();
    yardAreaController.dispose();
    garageController.dispose();
    maintenanceController.dispose();

    // Payment plan controllers
    // Removed disposal of payPlanPhase0Controller, payPlanPhase1Controller, payPlanPhase2Controller
    payPlanDurationValue0Controller.dispose();
    payPlanDurationUnit0Controller.dispose();
    payPlanPercentage0Controller.dispose();
    payPlanDurationValue1Controller.dispose();
    payPlanDurationUnit1Controller.dispose();
    payPlanPercentage1Controller.dispose();
    payPlanDurationValue2Controller.dispose();
    payPlanDurationUnit2Controller.dispose();
    payPlanPercentage2Controller.dispose();

    // Dispose PageController
    paymentPageController.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    paymentPageController = PageController(); // تهيئة PageController
  }

  // These are not Text Controllers; they are Rx variables for IDs
  final countryId =
      1.obs; // Consider if these should be `Rxn<int>` and updated from UI dropdowns
  final cityId =
      1.obs; // Consider if these should be `Rxn<int>` and updated from UI dropdowns
  final ownershipTypeId =
      1.obs; // Consider if this should be `Rxn<int>` and updated from UI dropdowns

  final exposureList = <int>[].obs;

  void updateExposureList() {
    exposureList.clear();
    for (var direction in selectedDirections) {
      final d = direction.toLowerCase();
      if (d == 'north') {
        exposureList.add(1);
      } else if (d == 'south')
        exposureList.add(2);
      else if (d == 'east')
        exposureList.add(3);
      else if (d == 'west')
        exposureList.add(4);
      else if (d == 'northeast')
        exposureList.add(5);
      else if (d == 'northwest')
        exposureList.add(6);
      else if (d == 'southeast')
        exposureList.add(7);
      else if (d == 'southwest')
        exposureList.add(8);
    }
  }

  void updateAmenitiesList() {
    amenitiesController.selectedAmenityIds
        .clear(); // Ensure this is selectedAmenityIds not selectedAmenities
    final allAmenities = amenitiesController.amenitiesModel.value.data;
    for (var selectedAmenityName in amenitiesController.selectedAmenities) {
      final amenity = allAmenities.firstWhereOrNull(
            (datum) => datum.name == selectedAmenityName,
      );
      if (amenity != null) {
        amenitiesController.selectedAmenityIds.add(
          amenity.id,
        ); // Assuming amenity.id is int
      }
    }
  }

  Future<void> submitProperty() async {
    isLoading.value = true;
    final api = ApiService();
    final sellType = selectedSellTypeIndex.value;
    final propertyType = selectedPropertyTypeIndex.value;

    updateExposureList();
    updateAmenitiesList();

    int sellTypeValue;
    if (sellType == 0) {
      sellTypeValue = 2; // Rent
    } else if (sellType == 1) {
      sellTypeValue = 1; // Sale
    } else {
      sellTypeValue = 3; // Off Plan
    }
    int propertyTypeId;
    int? residentialPropertyTypeId;
    int? commercialPropertyTypeId;

    if (propertyType == 0 || propertyType == 1) {
      // Apartment or Villa
      propertyTypeId = 1; // Residential
      if (propertyType == 0 && sellType == 0) {
        residentialPropertyTypeId = 1;
      } // Apartment for Rent
      else if (propertyType == 1 && sellType == 0) {
        residentialPropertyTypeId = 2;
      } // Villa for Rent
      else if (propertyType == 0 && sellType == 1) {
        residentialPropertyTypeId = 1;
      } // Apartment for Sale
      else if (propertyType == 1 && sellType == 1) {
        residentialPropertyTypeId = 2;
      } // Villa for Sale
      else if (propertyType == 0 && sellType == 2) {
        residentialPropertyTypeId = 1;
      } // Apartment for Off Plan
      else if (propertyType == 1 && sellType == 2) {
        residentialPropertyTypeId = 2;
      } // Villa for Off Plan
    } else if (propertyType == 2) {
      // Office
      propertyTypeId = 2; // Commercial
      commercialPropertyTypeId = 1; // Office Commercial Type ID (example)
    } else {
      propertyTypeId = 1; // Defaulting to residential if none matches
    }

    // Helper to safely parse string to int, returning null if empty or invalid
    int? safeParseInt(TextEditingController controller) {
      final text = controller.text.trim();
      if (text.isEmpty) return null;
      return int.tryParse(text);
    }

    // Helper to safely parse string to double, returning null if empty or invalid
    double? safeParseDouble(TextEditingController controller) {
      final text = controller.text.trim();
      if (text.isEmpty) return null;
      return double.tryParse(text);
    }

    // Base body includes common fields, ensuring numeric fields are parsed
    final Map<String, dynamic> baseBody = {
      'country_id': selectedCountryId.value?.toString() ?? '',
      'city_id': selectedCityId.value?.toString() ?? '',
      'latitude': selectedLocation.value?.latitude.toString() ?? '',
      'longitude': selectedLocation.value?.longitude.toString() ?? '',
      'additional_info': additionalInfo.text,
      'area': safeParseDouble(areaController),
      // Using areaController from top
      'bathrooms': safeParseInt(bathroomsController),
      // Using bathroomsController from top
      'balconies': safeParseInt(balconiesController),
      // Using balconiesController from top
      'ownership_type_id': ownershipTypeId.value.toString(),
      'property_type_id': propertyTypeId.toString(),
      'sell_type_id': sellTypeValue.toString(),
    };

    if (residentialPropertyTypeId != null) {
      baseBody['residential_property_type_id'] =
          residentialPropertyTypeId.toString();
    }
    if (commercialPropertyTypeId != null) {
      baseBody['commercial_property_type_id'] =
          commercialPropertyTypeId.toString();
    }

    // Add exposure list (if any)
    for (var i = 0; i < exposureList.length; i++) {
      baseBody['exposure[$i]'] = exposureList[i].toString();
    }

    // Add amenities list (if any)
    if (amenitiesController.selectedAmenityIds.isNotEmpty) {
      for (var i = 0; i < amenitiesController.selectedAmenityIds.length; i++) {
        baseBody['amenities[$i]'] =
            amenitiesController.selectedAmenityIds[i].toString();
      }
    }

    final body = {...baseBody}; // Start with the base body

    if (propertyType == 0) {
      // Apartment
      if (sellType == 0) {
        // Rent (Apartment)
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnit.value,
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'bedrooms': safeParseInt(bedroomsController),
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      } else if (sellType == 1) {
        // Sale (Apartment)
        body.addAll({
          'price': safeParseDouble(priceController),
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'bedrooms': safeParseInt(bedroomsController),
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      } else if (sellType == 2) {
        // Off Plan (Apartment)
        body.addAll({
          'delivery_date': deliveryDateController.text,
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          // Structured payment_plan for Off Plan properties
          // Check if at least the first payment plan phase is provided
          if (payPlanDurationValue0Controller.text.isNotEmpty ||
              payPlanDurationUnit0Controller.text.isNotEmpty ||
              payPlanPercentage0Controller.text.isNotEmpty) ...{
            'payment_plan[0][payment_phase_id]': '1', // Hardcoded
            'payment_plan[0][duration_value]': safeParseInt(
              payPlanDurationValue0Controller,
            ),
            'payment_plan[0][duration_unit]':
            payPlanDurationUnit0Controller.text,
            'payment_plan[0][payment_percentage]':
            payPlanPercentage0Controller.text,
          },
          if (payPlanDurationValue1Controller.text.isNotEmpty ||
              payPlanDurationUnit1Controller.text.isNotEmpty ||
              payPlanPercentage1Controller.text.isNotEmpty) ...{
            'payment_plan[1][payment_phase_id]': '2', // Hardcoded
            'payment_plan[1][duration_value]': safeParseInt(
              payPlanDurationValue1Controller,
            ),
            'payment_plan[1][duration_unit]':
            payPlanDurationUnit1Controller.text,
            'payment_plan[1][payment_percentage]':
            payPlanPercentage1Controller.text,
          },
          if (payPlanDurationValue2Controller.text.isNotEmpty ||
              payPlanDurationUnit2Controller.text.isNotEmpty ||
              payPlanPercentage2Controller.text.isNotEmpty) ...{
            'payment_plan[2][payment_phase_id]': '3', // Hardcoded
            'payment_plan[2][duration_value]': safeParseInt(
              payPlanDurationValue2Controller,
            ),
            'payment_plan[2][duration_unit]':
            payPlanDurationUnit2Controller.text,
            'payment_plan[2][payment_percentage]':
            payPlanPercentage2Controller.text,
          },
          'bedrooms': safeParseInt(bedroomsController),
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      }
    } else if (propertyType == 1) {
      // Villa
      if (sellType == 0) {
        // Rent (Villa)
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnit.value,
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'bedrooms': safeParseInt(bedroomsController),
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
          // For villas, floor number might be less common or handled differently
        });
      } else if (sellType == 1) {
        // Sale (Villa)
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnit.value,
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'bedrooms': safeParseInt(bedroomsController),
          'floors': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      } else if (sellType == 2) {
        // Off Plan (Villa)
        body.addAll({
          'delivery_date': deliveryDateController.text,
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          // Structured payment_plan for Off Plan properties
          if (payPlanDurationValue0Controller.text.isNotEmpty ||
              payPlanDurationUnit0Controller.text.isNotEmpty ||
              payPlanPercentage0Controller.text.isNotEmpty) ...{
            'payment_plan[0][payment_phase_id]': '1', // Hardcoded
            'payment_plan[0][duration_value]': safeParseInt(
              payPlanDurationValue0Controller,
            ),
            'payment_plan[0][duration_unit]':
            payPlanDurationUnit0Controller.text,
            'payment_plan[0][payment_percentage]':
            payPlanPercentage0Controller.text,
          },
          if (payPlanDurationValue1Controller.text.isNotEmpty ||
              payPlanDurationUnit1Controller.text.isNotEmpty ||
              payPlanPercentage1Controller.text.isNotEmpty) ...{
            'payment_plan[1][payment_phase_id]': '2', // Hardcoded
            'payment_plan[1][duration_value]': safeParseInt(
              payPlanDurationValue1Controller,
            ),
            'payment_plan[1][duration_unit]':
            payPlanDurationUnit1Controller.text,
            'payment_plan[1][payment_percentage]':
            payPlanPercentage1Controller.text,
          },
          if (payPlanDurationValue2Controller.text.isNotEmpty ||
              payPlanDurationUnit2Controller.text.isNotEmpty ||
              payPlanPercentage2Controller.text.isNotEmpty) ...{
            'payment_plan[2][payment_phase_id]': '3', // Hardcoded
            'payment_plan[2][duration_value]': safeParseInt(
              payPlanDurationValue2Controller,
            ),
            'payment_plan[2][duration_unit]':
            payPlanDurationUnit2Controller.text,
            'payment_plan[2][payment_percentage]':
            payPlanPercentage2Controller.text,
          },
          'bedrooms': safeParseInt(bedroomsController),
          'floors': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      }
    } else if (propertyType == 2) {
      // Office
      if (sellType == 0) {
        // Rent (Office)
        body.addAll({
          'price': safeParseDouble(priceController),
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnit.value,
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'bathrooms': safeParseInt(bathroomsController),
          // Offices usually have bathrooms, no bedrooms/balconies
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      } else if (sellType == 1) {
        // Sale (Office)
        body.addAll({
          'area': safeParseDouble(priceController),
          'price': safeParseDouble(priceController),
          'bathrooms': safeParseInt(bathroomsController),
          'balconies': safeParseInt(balconiesController),
          'floor': safeParseInt(floorNumberController),
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
          'is_furnished': furnishing.value.toLowerCase() == 'yes' ? '1' : '0',
          'lease_period_value': safeParseInt(leasePeriodValueController),
          'lease_period_unit': leasePeriodUnit.value,
        });
      } else if (sellType == 2) {
        // Off Plan (Office)
        body.addAll({
          'delivery_date': deliveryDateController.text,
          'first_pay': safeParseDouble(firstPayController),
          'overall_payment': safeParseDouble(overallPaymentController),
          if (payPlanDurationValue0Controller.text.isNotEmpty ||
              payPlanDurationUnit0Controller.text.isNotEmpty ||
              payPlanPercentage0Controller.text.isNotEmpty) ...{
            'payment_plan[0][payment_phase_id]': '1', // Hardcode to '1'
            'payment_plan[0][duration_value]': safeParseInt(
              payPlanDurationValue0Controller,
            ),
            'payment_plan[0][duration_unit]':
            payPlanDurationUnit0Controller.text,
            'payment_plan[0][payment_percentage]':
            payPlanPercentage0Controller.text,
          },
          // For Payment Plan Phase 1
          if (payPlanDurationValue1Controller.text.isNotEmpty ||
              payPlanDurationUnit1Controller.text.isNotEmpty ||
              payPlanPercentage1Controller.text.isNotEmpty) ...{
            'payment_plan[1][payment_phase_id]': '2', // Hardcode to '2'
            'payment_plan[1][duration_value]': safeParseInt(
              payPlanDurationValue1Controller,
            ),
            'payment_plan[1][duration_unit]':
            payPlanDurationUnit1Controller.text,
            'payment_plan[1][payment_percentage]':
            payPlanPercentage1Controller.text,
          },
          // For Payment Plan Phase 2
          if (payPlanDurationValue2Controller.text.isNotEmpty ||
              payPlanDurationUnit2Controller.text.isNotEmpty ||
              payPlanPercentage2Controller.text.isNotEmpty) ...{
            'payment_plan[2][payment_phase_id]': '3', // Hardcode to '3'
            'payment_plan[2][duration_value]': safeParseInt(
              payPlanDurationValue2Controller,
            ),
            'payment_plan[2][duration_unit]':
            payPlanDurationUnit2Controller.text,
            'payment_plan[2][payment_percentage]':
            payPlanPercentage2Controller.text,
          },
          'floor': safeParseInt(floorNumberController),
          // Use off-plan floor controller for consistency
          'building_number': safeParseInt(buildingNumberController),
          'apartment_number': safeParseInt(apartmentNumberController),
        });
      }
    }

    // Filter out null values.
    body.removeWhere((key, value) => value == null);

    print("--- FINAL BODY PAYLOAD SENT ---");
    print(body);

    try {
      String endpoint = ApiEndpoints.addProperty;

      if (selectedImages.length < 3) {
        Get.snackbar(
          'Error',
          'Please select at least 3 images for the property.',
        );
        return;
      }
      // if (selectedVideo.value == null) {
      //   // Check if a video is selected
      //   Get.snackbar(
      //     'Error',
      //     'Please select at least 1 video for the property.',
      //   );
      //
      //
      //   return;
      // }

      // Combine images and video into a single list for upload, or handle separately if API expects different keys
      final List<File> filesToUpload = [...selectedImages];
      if (selectedVideo.value != null) {
        filesToUpload.add(selectedVideo.value!);
      }

      final response = await api.uploadFiles(
        url: endpoint,
        files: filesToUpload,
        fileKey: 'images',
        // You might need to change this if your API expects a different key for videos (e.g., 'media' or separate 'images' and 'video' keys)
        fields: body.map(
              (key, value) => MapEntry(key, value.toString()),
        ), // Convert all values to string for multipart form data
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Property added successfully',
        );
        Get.offAllNamed(Routes.PropertiesUnifiedView);
      } else {
        String errorMessage =
            response.body['message'] ?? 'Failed to add property';

        if (response.body['errors'] != null) {
          response.body['errors'].forEach((key, value) {
            errorMessage += "\n$key: ${value.join(', ')}";
          });
        }
        Get.snackbar(
          'Error',
          errorMessage,
          duration: const Duration(seconds: 5),
        );
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }
}