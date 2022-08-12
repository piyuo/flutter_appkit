//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/log/log.dart' as log;

/// deviceLatLng return device location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
///

Future<types.LatLng> deviceLatLng() async {
  bool serviceEnabled;
  LocationPermission permissionGranted;
  Position locationData;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return types.LatLng.empty;
  }

  permissionGranted = await Geolocator.checkPermission();
  if (permissionGranted == LocationPermission.denied) {
    permissionGranted = await Geolocator.requestPermission();
    if (permissionGranted == LocationPermission.denied) {
      return types.LatLng.empty;
    }
  }

  try {
    locationData = await Geolocator.getCurrentPosition();
    return types.LatLng(locationData.latitude, locationData.longitude);
  } catch (e, s) {
    log.error(e, s);
  }
  return types.LatLng.empty;
}


/*
Future<types.LatLng> deviceLatLng() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return types.LatLng.empty;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return types.LatLng.empty;
    }
  }

  try {
    locationData = await location.getLocation();
    return types.LatLng(locationData.latitude!, locationData.longitude!);
  } catch (e, s) {
    log.error(e, s);
  }
  return types.LatLng.empty;
}

*/