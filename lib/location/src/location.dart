import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:libcli/general/general.dart' as general;
import 'package:libcli/log/log.dart' as log;

/// deviceLatLng return device location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
/// ```dart
/// final latLng = await deviceLatLng();
/// ```
Future<general.LatLng> deviceLatLng() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return general.LatLng.empty;
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log.log('Location services are disabled.');
      return general.LatLng.empty;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    log.log('Location permissions are permanently denied, we cannot request permissions.');
    return general.LatLng.empty;
  }

  try {
    Position locationData = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint('lat: ${locationData.latitude}, lng: ${locationData.longitude}');
    return general.LatLng(locationData.latitude, locationData.longitude);
  } catch (e, s) {
    log.error(e, s);
  }
  return general.LatLng.empty;
}
