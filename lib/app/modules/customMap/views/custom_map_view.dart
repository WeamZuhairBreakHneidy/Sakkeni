import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/custom_map_controller.dart';
import '../widgets/custom_map.dart';

class CustomMapView extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  CustomMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomMapController mapController = Get.put(CustomMapController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with GetX'),
        actions: [
          Obx(() => IconButton(
            icon: mapController.isLoading.value
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : Icon(Icons.my_location),
            onPressed: () => mapController.getCurrentLocation(),
            tooltip: 'Take Me To My Location',
          )),
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
                  DropdownMenuItem(value: MapType.normal, child: Text('Default')),
                  DropdownMenuItem(value: MapType.satellite, child: Text('Satellite')),
                  DropdownMenuItem(value: MapType.terrain, child: Text('Terrain')),
                  DropdownMenuItem(value: MapType.hybrid, child: Text('Hybrid')),
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
