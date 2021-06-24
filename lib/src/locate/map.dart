import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:libcli/types.dart' as types;
import 'package:libcli/i18n.dart' as i18n;
import 'map-google.dart';
import 'map-apple.dart';
import 'map-amap.dart';

/// MapProviderImpl is interface for map implementation
abstract class MapProviderImpl {
  types.LatLng latlng = types.LatLng.empty;

  bool showMarker = false;

  Future<void> setValue(types.LatLng l, bool show) async {
    latlng = l;
    showMarker = show;
  }
}

/// MapProvider control map
class MapProvider with ChangeNotifier {
  MapProvider(this.impl);

  // impl is map implementation
  MapProviderImpl impl;

  Future<void> setValue(types.LatLng l, bool show) async {
    impl.setValue(l, show);
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
abstract class Map extends StatelessWidget {}

/// platformMap return map by platform, web:google map, ios: apple map, cn: amap
///
///     map.platformMap(platformMapProvider)
///
Map platformMap() {
  if (kIsWeb) {
    // only google map support web
    return MapGoogle();
  }

  // always use apple map on ios, cause apple demand it
  if (Platform.isIOS) {
    return MapApple();
  }

  // use amap in china
  if (i18n.isCountryCN) {
    return MapAMap();
  }

//change android locale will result CERTIFICATE_VERIFY_FAILED, so we just do test in en_US
//  return MapAMap();

  // everything else use google map
  return MapGoogle();
}

/// platformMapProvider return map provider by platform, web:google map, ios: apple map, cn: amap
///
///     map.platformMapProvider()
///
MapProvider platformMapProvider() {
  if (kIsWeb) {
    // only google map support web
    return MapProvider(GoogleImpl());
  }

  // always use apple map on ios, cause apple demand it
  if (Platform.isIOS) {
    return MapProvider(AppleImpl());
  }

  // use amap in china
  if (i18n.isCountryCN) {
    return MapProvider(AmapImpl());
  }

//change android locale will result CERTIFICATE_VERIFY_FAILED, so we just do test in en_US
//  return MapAMap();

  // everything else use google map
  return MapProvider(GoogleImpl());
}
