import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:libcli/identifier.dart' as identifier;
import 'map.dart';

/// MapApple run ios apple map, no key required
class MapApple extends Map {
  MapApple(
    MapValueController controller, {
    Key? key,
  }) : super(controller, key: key);

  @override
  State<MapApple> createState() => MapAppleState();
}

class MapAppleState extends State<MapApple> {
  AppleMapController? _appleController;

  Set<Annotation> _markers = {};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onValueChange);
    resetMarker();
  }

  /// resetMarker reset marker position
  void resetMarker() {
    final l = widget.currentLatLng;
    _markers.clear();
    if (widget.showMarker) {
      _markers.add(
        Annotation(
            annotationId: AnnotationId(identifier.uuid()), // marker id must be unique
            position: LatLng(
              l.lat,
              l.lng,
            )),
      );
    }
  }

  /// onValueChange happen when user change value
  void onValueChange() async {
    setState(() {
      resetMarker();
    });

    final l = widget.controller.value.latlng;
    if (_appleController != null) {
      _appleController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.lat, l.lng),
            zoom: 18,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.controller.value.latlng;
    return AppleMap(
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      annotations: _markers,
      onMapCreated: (AppleMapController controller) {
        _appleController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(l.lat, l.lng),
        zoom: 18,
      ),
    );
  }
}
