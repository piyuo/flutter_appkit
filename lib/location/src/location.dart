import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:libcli/general/general.dart' as general;
import 'package:libcli/permission/permission.dart' as permission;

/// getCurrentLocation return device current location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
/// ```dart
/// final latLng = await getCurrentLocation('to show you nearby places');
/// ```
Future<general.LatLng?> getCurrentLocation(String reason) async {
  if (await permission.getLocationPermission(reason)) {
    Position locationData = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint('lat: ${locationData.latitude}, lng: ${locationData.longitude}');
    return general.LatLng(locationData.latitude, locationData.longitude);
  }
  debugPrint('user not allow location permission');
  return null;
}
