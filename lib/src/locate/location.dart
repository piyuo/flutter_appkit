import 'package:location/location.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/log.dart' as log;

/// deviceLatLng return device location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
///
Future<types.LatLng> deviceLatLngLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return types.LatLng.empty;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return types.LatLng.empty;
    }
  }

  try {
    _locationData = await location.getLocation();
    return types.LatLng(_locationData.latitude!, _locationData.longitude!);
  } catch (e, s) {
    log.error(e, s);
  }
  return types.LatLng.empty;
}


/*
Future<types.LatLng> deviceLatLngGeolocator() async {
  bool _serviceEnabled;
  LocationPermission _permissionGranted;
  Position _locationData;

  _serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!_serviceEnabled) {
    return types.LatLng.empty;
  }

  _permissionGranted = await Geolocator.checkPermission();
  if (_permissionGranted == LocationPermission.denied) {
    _permissionGranted = await Geolocator.requestPermission();
    if (_permissionGranted == LocationPermission.denied) {
      return types.LatLng.empty;
    }
  }

  try {
    _locationData = await Geolocator.getCurrentPosition();
    return types.LatLng(_locationData.latitude, _locationData.longitude);
  } catch (e, s) {
    log.error(e, s);
  }
  return types.LatLng.empty;
}
*/
