import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'map.dart';

/// AMapApiKey is amap.com key, you need generate android key
///  here is how to get sha1 for amap android key
/// https://stackoverflow.com/questions/15727912/sha-1-fingerprint-of-keystore-certificate
///
/// in android/app/src/build.gradle
/// add implementation 'com.amap.api:3dmap:latest.integration'
///
/// android/app/src/main/AndroidManifest.xml
/// <manifest ...
///   <application ...
///     <meta-data android:name="com.google.android.geo.API_KEY"
///                android:value="YOUR KEY HERE"/>
class MapAMap extends Map {
  MapAMap(
    MapValueController controller, {
    Key? key,
  }) : super(controller, key: key);

  @override
  State<MapAMap> createState() => MapAMapState();
}

class MapAMapState extends State<MapAMap> {
  AMapController? _amapController;

  Set<Marker> _markers = {};

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
        Marker(
            infoWindowEnable: false,
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
    if (_amapController != null) {
      _amapController!.moveCamera(
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
    return AMapWidget(
      markers: _markers,
      onMapCreated: (AMapController controller) {
        _amapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(l.lat, l.lng),
        zoom: 18,
      ),
    );
  }
}
