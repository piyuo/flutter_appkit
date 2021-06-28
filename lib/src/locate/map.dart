import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;

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
