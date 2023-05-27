import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:libcli/utils/utils.dart' as general;
import 'package:libcli/permission/permission.dart' as permission;
import 'package:libcli/log/log.dart' as log;

/// getCurrentLocation return device current location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
/// ```dart
/// final latLng = await getCurrentLocation('to show you nearby places');
/// ```
Future<general.LatLng?> getCurrentLocation(String reason) async {
  if (await permission.getLocationPermission(reason)) {
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
  debugPrint('user not allow location permission');
  return null;
}

/// getDistanceBetweenInMeters return distance in meters between two latLng
double getDistanceBetweenInMeters(general.LatLng latLng1, general.LatLng latLng2) {
  return Geolocator.distanceBetween(latLng1.lat, latLng1.lng, latLng2.lat, latLng2.lng);
}
