import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test1/app/core/theme/colors.dart';
import 'package:test1/app/widgets/responsive_buttun.dart';

import '../controllers/custom_map_controller.dart';
import '../widgets/custom_map.dart';

class CustomMapView extends StatelessWidget {
  final bool returnLocation; // Whether to return picked location on submit
  final TextEditingController searchController = TextEditingController();

  CustomMapView({super.key, this.returnLocation = false});

  @override
  Widget build(BuildContext context) {
    final CustomMapController mapController = Get.put(CustomMapController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Colors.transparent,

      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search + dropdown row
              Container(

                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for a place',
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: Obx(() {
                            if (mapController.isSearching.value) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            }
                            return IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                mapController.searchAndNavigate(searchController.text);
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  12.horizontalSpace,
                    Expanded(
                      flex: 3,
                      child: Obx(() {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<MapType>(
                              value: mapController.mapType.value,
                              isExpanded: true,
                              icon: Icon(Icons.map, color: AppColors.primary),
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
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(child: CustomMap()),
            ],
          ),

          // Submit button floating above map at bottom
          Positioned(
            bottom: 24.h,
            left: 60.w,
            right: 60.w,
            child: Obx(() {
              final hasSearchMarker = mapController.markers.any(
                      (m) => m.markerId.value == 'searched_location');
              if (!returnLocation || !hasSearchMarker) {
                return SizedBox.shrink();
              }
              return ResponsiveButton(

                buttonStyle:ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    backgroundColor: AppColors.primary
                  ) ,
                  onPressed: () {
                final marker = mapController.markers.firstWhere(
                        (m) => m.markerId.value == 'searched_location');
                Get.back(result: marker.position);
              } , clickable: true,

                child: Text(
                  "Submit",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                ));
            }),
          ),

          // Optional: show loading indicator overlay during location fetch
          Obx(() {
            if (mapController.isLoading.value) {
              return Container(
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
