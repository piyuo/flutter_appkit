import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:libcli/types.dart' as types;
import 'package:libcli/i18n.dart' as i18n;
import 'map-google.dart';
import 'map-apple.dart';
import 'map-amap.dart';

/// MapValue represent how to show map
class MapValue {
  MapValue({
    required this.latlng,
    required this.showMarker,
  });

  final types.LatLng latlng;

  final bool showMarker;

  static MapValue empty = MapValue(
    showMarker: false,
    latlng: types.LatLng.empty,
  );

  bool get isEmpty => latlng.isEmpty;
}

/// MapValueController
class MapValueController extends ValueNotifier<MapValue> {
  MapValueController({MapValue? value}) : super(value ?? MapValue.empty);
}

/// Map is abstract map
abstract class Map extends StatefulWidget {
  Map(this.controller, {Key? key}) : super(key: key);

  /// controller control map value
  final MapValueController controller;

  /// controller control map value
  types.LatLng get currentLatLng => controller.value.latlng;

  /// showMarker true mean
  bool get showMarker {
    return controller.value.showMarker;
  }
}

/// platformMap return map by platform, web:google map, ios: apple map, cn: amap
///
///     map.platformMap(widget.mapController)
///
Map platformMap(
  MapValueController controller, {
  Key? key,
}) {
  if (kIsWeb) {
    // only google map support web
    return MapGoogle(controller, key: key);
  }

  // always use apple map on ios, cause apple demand it
  if (Platform.isIOS) {
    return MapApple(controller, key: key);
  }

  // use amap in china
  if (i18n.isCountryCN) {
    return MapAMap(controller, key: key);
  }

//change android locale will result CERTIFICATE_VERIFY_FAILED, so we just do test in en_US
//  return MapAMap(controller, key: key);

  // everything else use google map
  return MapGoogle(controller, key: key);
}
