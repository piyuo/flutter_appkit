import 'package:location/location.dart';
import 'package:libcli/types.dart' as types;

/// deviceLatLng return device location info, return empty if can't not get device location (user not allow)
/// this function is slow, it may takes few seconds to complete
///
Future<types.LatLng> deviceLatLng() async {
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
