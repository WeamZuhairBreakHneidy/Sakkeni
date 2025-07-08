import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddpropertyController extends GetxController {
  final location = TextEditingController();
  final selectedDirections = <String>[].obs;

  final selectedLocation = Rxn<LatLng>();

  void updateLocation(LatLng latLng) {
    selectedLocation.value = latLng;
    location.text = "${latLng.latitude}, ${latLng.longitude}";
  }

  void toggleDirection(String direction) {
    if (selectedDirections.contains(direction)) {
      selectedDirections.remove(direction);
    } else {
      selectedDirections.add(direction);
    }
  }
}
