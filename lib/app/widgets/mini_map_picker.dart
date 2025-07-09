import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../modules/addproperty/controllers/add_property_controller.dart';
import '../modules/customMap/views/custom_map_view.dart';
class MiniMapPicker extends StatelessWidget {
  final AddpropertyController controller = Get.find();

  MiniMapPicker({super.key});

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      print("Failed to get address: $e");
    }
    return 'Unknown location';
  }

  Future<void> _initDefaultLocation() async {
    if (controller.selectedLocation.value != null) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) return;
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng current = LatLng(pos.latitude, pos.longitude);
      controller.updateLocation(current);

      final address = await _getAddressFromLatLng(current);
      controller.location.text = address;
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _initDefaultLocation();

    return GestureDetector(
      onTap: () async {
        LatLng? result =
        await Get.to(() => CustomMapView(returnLocation: true));
        if (result != null) {
          controller.updateLocation(result);
          final address = await _getAddressFromLatLng(result);
          controller.location.text = address;
        }
      },
      child: Obx(() {
        final latLng = controller.selectedLocation.value;

        return Container(
          height: 190,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: latLng == null
              ? const Center(child: Text("Fetching location..."))
              : ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: latLng, zoom: 14),
                  onMapCreated: controller.setMapController,
                  markers: {
                    Marker(
                        markerId: const MarkerId("selected"),
                        position: latLng),
                  },
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  liteModeEnabled: false, // ❗ allow camera animation
                  onTap: (_) {}, // disable interaction
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: FutureBuilder<String>(
                    future: _getAddressFromLatLng(latLng),
                    builder: (context, snapshot) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          snapshot.data ?? 'Loading address...',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
