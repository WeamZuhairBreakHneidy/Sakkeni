import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CustomMapController extends GetxController {
  var markers = <Marker>[].obs;
  late GoogleMapController googleMapController;

  var mapType = MapType.normal.obs; // Default map type
  var isLoading = false.obs;
  var myCurrentLocation = Rxn<LatLng>();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    // If location already fetched, move camera to it
    if (myCurrentLocation.value != null) {
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(myCurrentLocation.value!, 14),
      );
    }
  }

  void changeMapType(MapType newType) {
    mapType.value = newType;
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied');
        isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      myCurrentLocation.value = currentLatLng;

      // Add or update "my location" marker without clearing other markers
      markers.removeWhere((m) => m.markerId.value == 'my_location');
      markers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: currentLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: 'My Location'),
        ),
      );

      // Move camera to current location
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 14.0),
      );
    } catch (e) {
      print("Location error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMarker(LatLng position) async {
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      print("Placemarks: $placemarks");
      print("${position.latitude} + ${position.longitude}");
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String title = '${place.locality}, ${place.administrativeArea}, ${place.country}';

        // Clear only search markers, keep my_location marker
        markers.removeWhere((m) => m.markerId.value == 'searched_location');

        markers.add(
          Marker(
            markerId: MarkerId('searched_location'),
            position: position,
            infoWindow: InfoWindow(title: title),
          ),
        );
      }
    } catch (e) {
      print("Error occurred while adding marker: $e");
    }
  }

  Future<void> searchAndNavigate(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng target = LatLng(location.latitude, location.longitude);

        double zoomLevel = 14.0;
        if (address.toLowerCase().contains('america')) zoomLevel = 3.0;
        if (address.toLowerCase().contains('india')) zoomLevel = 5.0;

        await addMarker(target);

        googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(target, zoomLevel),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
