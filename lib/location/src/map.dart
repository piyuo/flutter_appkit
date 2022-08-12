import 'package:flutter/material.dart';
import 'package:libcli/types/types.dart' as types;

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
