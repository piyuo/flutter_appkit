import 'package:flutter/material.dart';
import 'package:libcli/general/general.dart' as types;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_platform/universal_platform.dart';
import 'map_google.dart';
import 'map_apple.dart';

/// MapProviderImpl is interface for map implementation
abstract class MapProviderImpl {
  types.LatLng latlng = types.LatLng.empty;

  bool showMarker = false;

  Future<void> setValue(types.LatLng latlng, bool showMarker) async {
    latlng = latlng;
    showMarker = showMarker;
  }
}

/// MapProvider control map
class MapProvider with ChangeNotifier {
  MapProvider(this.impl);

  // impl is map implementation
  MapProviderImpl impl;

  Future<void> setValue(types.LatLng latlng, bool showMarker) async {
    impl.setValue(latlng, showMarker);
    notifyListeners();
  }

  types.LatLng get latlng {
    return impl.latlng;
  }

  bool get showMarker {
    return impl.showMarker;
  }
}

/// Map is abstract map
abstract class Map extends StatelessWidget {
  const Map({Key? key}) : super(key: key);
}

enum LocationMapType { google, apple } //, amap

LocationMapType mapType() {
  if (kIsWeb) {
    // only google map support web
    return LocationMapType.google;
  }

  // always use apple map on ios, cause apple demand it
  if (UniversalPlatform.isIOS) {
    return LocationMapType.apple;
  }

  // use amap in china, cause google map may not work in china
  //if (i18n.countryCode == 'CN') {
  //  return MapType.amap;
  //}

  //debug
  // return MapType.amap;

  // everything else use google map
  return LocationMapType.google;
}

/// map return map by platform, web:google map, ios: apple map, cn: amap
Map map() {
  switch (mapType()) {
    case LocationMapType.apple:
      return const MapApple();
    //case MapType.amap:
    //  return const MapAMap();
    default:
      return const MapGoogle();
  }
}

/// map return map by platform, web:google map, ios: apple map, cn: amap
MapProvider mapProvider() {
  switch (mapType()) {
    case LocationMapType.apple:
      return MapProvider(AppleImpl());
    //case MapType.amap:
    //  return MapProvider(AmapImpl());
    default:
      return MapProvider(GoogleImpl());
  }
}

/// mapUrl return url by platform, web:google map, ios: apple map, cn: amap
String mapUrl(String address, types.LatLng latlng) {
  String adr = Uri.encodeComponent(address);
  var t = mapType();
  if (t == LocationMapType.apple) {
    //if (i18n.countryCode == 'CN') {
    //  t = MapType.amap;
    //  } else {
//    }
    t = LocationMapType.google;
  }

  switch (t) {
    //case MapType.amap: // amap is lng first
    // return 'https://uri.amap.com/marker?position=${latlng.lng},${latlng.lat}&name=$adr&callnative=1';
    //case MapType.apple: // apple map is not accurate in china
    //  return 'http://maps.apple.com/?address=$adr&z=18';
    default:
      return 'https://maps.google.com/?q=$adr&z=18';
  }
}
