import 'package:location/location.dart';
import 'package:libcli/types.dart' as types;

/// return user current location, return empty if user not give his location
///
Future<types.LatLng> current() async {
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

  _locationData = await location.getLocation();
  return types.LatLng(_locationData.latitude!, _locationData.longitude!);
}
