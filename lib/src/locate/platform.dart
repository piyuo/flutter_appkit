import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/types.dart' as types;
import 'map_google.dart';
import 'map_apple.dart';
import 'map_amap.dart';
import 'map.dart';

enum MapType { google, apple, amap }

MapType mapType() {
  if (kIsWeb) {
    // only google map support web
    return MapType.google;
  }

  // always use apple map on ios, cause apple demand it
  if (Platform.isIOS) {
    return MapType.apple;
  }

  // use amap in china, cause google map may not work in china
  if (i18n.isCountryCN) {
    return MapType.amap;
  }

  //debug
  // return MapType.amap;

  // everything else use google map
  return MapType.google;
}

/// map return map by platform, web:google map, ios: apple map, cn: amap
///
///     map(provider)
///
Map map() {
  switch (mapType()) {
    case MapType.apple:
      return const MapApple();
    case MapType.amap:
      return const MapAMap();
    default:
      return const MapGoogle();
  }
}

/// map return map by platform, web:google map, ios: apple map, cn: amap
///
///     mapProvider()
///
MapProvider mapProvider() {
  switch (mapType()) {
    case MapType.apple:
      return MapProvider(AppleImpl());
    case MapType.amap:
      return MapProvider(AmapImpl());
    default:
      return MapProvider(GoogleImpl());
  }
}

/// mapUrl return url by platform, web:google map, ios: apple map, cn: amap
///
///     mapUrl(latlng)
///
String mapUrl(String address, types.LatLng latlng) {
  String adr = Uri.encodeComponent(address);
  var t = mapType();
  if (t == MapType.apple) {
    if (i18n.isCountryCN) {
      t = MapType.amap;
    } else {
      t = MapType.google;
    }
  }

  switch (t) {
    case MapType.amap: // amap is lng first
      return 'https://uri.amap.com/marker?position=${latlng.lng},${latlng.lat}&name=$adr&callnative=1';
    //case MapType.apple: // apple map is not accurate in china
    //  return 'http://maps.apple.com/?address=$adr&z=18';
    default:
      return 'https://maps.google.com/?q=$adr&z=18';
  }
}
