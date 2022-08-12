import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/generator/generator.dart' as generator;
import 'map.dart';

/// AppleImpl is apple map implementation
class AppleImpl extends MapProviderImpl {
  AppleMapController? _controller;

  final Set<Annotation> _markers = {};

  @override
  Future<void> setValue(types.LatLng latlng, bool showMarker) async {
    await super.setValue(latlng, showMarker);
    resetMarker();

    if (_controller != null) {
      _controller!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latlng.lat, latlng.lng),
            zoom: 18,
          ),
        ),
      );
    }
  }

  /// resetMarker reset marker position
  void resetMarker() {
    _markers.clear();
    if (showMarker) {
      _markers.add(
        Annotation(
            annotationId: AnnotationId(generator.uuid()), // marker id must be unique
            position: LatLng(
              latlng.lat,
              latlng.lng,
            )),
      );
    }
  }
}

/// MapApple run ios apple map, no key required
class MapApple extends Map {
  const MapApple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, mapProvider, child) {
      final impl = mapProvider.impl as AppleImpl;
      return mapProvider.latlng.isEmpty
          ? Container(color: Colors.grey[300])
          : AppleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              annotations: impl._markers,
              onMapCreated: (AppleMapController controller) {
                impl._controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(mapProvider.latlng.lat, mapProvider.latlng.lng),
                zoom: 18,
              ),
            );
    });
  }
}
