import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/custom_map_controller.dart';

class CustomMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CustomMapController mapController = Get.find();

    return Obx(() {
      return GoogleMap(
        onMapCreated: mapController.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: mapController.myCurrentLocation.value ?? LatLng(0, 0),
          zoom: 14,
        ),
        mapType: mapController.mapType.value,
        markers: mapController.markers.toSet(),
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        compassEnabled: true,
        onTap: (position) => mapController.addMarker(position),
      );
    });
  }
}
