import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/custom_map_controller.dart';
import '../widgets/custom_map.dart';

class CustomMapView extends StatelessWidget {
  final bool returnLocation; // Add this to optionally return LatLng
  final TextEditingController searchController = TextEditingController();

  CustomMapView({this.returnLocation = false});

  @override
  Widget build(BuildContext context) {
    final CustomMapController mapController = Get.put(CustomMapController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          Obx(() => IconButton(
            icon: mapController.isLoading.value
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : Icon(Icons.my_location),
            onPressed: () => mapController.getCurrentLocation(),
            tooltip: 'Take Me To My Location',
          )),
          if (returnLocation)
            Obx(() {
              final hasSearchMarker = mapController.markers.any(
                      (m) => m.markerId.value == 'searched_location');
              return hasSearchMarker
                  ? TextButton(
                onPressed: () {
                  final marker = mapController.markers.firstWhere(
                          (m) => m.markerId.value == 'searched_location');
                  Get.back(result: marker.position);
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : SizedBox.shrink();
            }),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: DropdownButton<MapType>(
                value: mapController.mapType.value,
                isExpanded: true,
                underline: Container(height: 1, color: Colors.grey),
                onChanged: (MapType? newType) {
                  if (newType != null) {
                    mapController.changeMapType(newType);
                  }
                },
                items: [
                  DropdownMenuItem(child: Text('Default'), value: MapType.normal),
                  DropdownMenuItem(child: Text('Satellite'), value: MapType.satellite),
                  DropdownMenuItem(child: Text('Terrain'), value: MapType.terrain),
                  DropdownMenuItem(child: Text('Hybrid'), value: MapType.hybrid),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    mapController.searchAndNavigate(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(child: CustomMap()),
        ],
      ),
    );
  }
}
