import 'package:location/location.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/i18n.dart' as i18n;

/// deviceLatLng return device location info, return empty if can't not get device location (user not allow)
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

/// countryLatLng return default location info by country
///
types.LatLng countryLatLng() {
  switch (i18n.country) {
    case i18n.CN:
      return types.LatLng(31.237988, 121.490218);
    case i18n.TW:
      return types.LatLng(25.033092, 121.564289);
  }
  return types.LatLng(40.759678, -73.984920);
}
