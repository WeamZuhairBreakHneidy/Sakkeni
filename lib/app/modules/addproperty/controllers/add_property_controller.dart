import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddpropertyController extends GetxController {
  final location = TextEditingController();
  final selectedDirections = <String>[].obs;
  final selectedLocation = Rxn<LatLng>();
  GoogleMapController? mapController;

  void updateLocation(LatLng latLng) {
    selectedLocation.value = latLng;
    location.text = "${latLng.latitude}, ${latLng.longitude}";
    animateToLocation(latLng);
  }

  void animateToLocation(LatLng latLng) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 14),
      );
    }
  }
  void toggleDirection(String direction) {
    if (selectedDirections.contains(direction)) {
      selectedDirections.remove(direction);
    } else {
      selectedDirections.add(direction);
    }
  }
  void setMapController(GoogleMapController controller) {
    mapController = controller;
    if (selectedLocation.value != null) {
      animateToLocation(selectedLocation.value!);
    }
  }
}
