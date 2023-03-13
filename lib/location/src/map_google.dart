import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:libcli/general/general.dart' as types;
import 'package:libcli/generator/generator.dart' as generator;
import 'map.dart';

/// GoogleImpl is google map implementation
class GoogleImpl extends MapProviderImpl {
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  @override
  Future<void> setValue(types.LatLng latlng, bool showMarker) async {
    await super.setValue(latlng, showMarker);
    resetMarker();

    final GoogleMapController futureController = await _controller.future;
    futureController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latlng.lat, latlng.lng),
      zoom: 18,
    )));
  }

  /// resetMarker reset marker position
  void resetMarker() {
    _markers.clear();
    if (showMarker) {
      _markers.add(
        Marker(
            markerId: MarkerId(generator.uuid()), // marker id must be unique
            position: LatLng(
              latlng.lat,
              latlng.lng,
            )),
      );
    }
  }
}

/// MapGoogle need setup Key
///
/// android/app/src/main/AndroidManifest.xml
/// <manifest ...
///   <application ...
///     <meta-data android:name="com.google.android.geo.API_KEY"
///                android:value="YOUR KEY HERE"/>
///
///  ios/Runner/AppDelegate.swift
/// @UIApplicationMain
/// @objc class AppDelegate: FlutterAppDelegate {
///   override func application(
///     _ application: UIApplication,
///     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
///   ) -> Bool {
///     GMSServices.provideAPIKey("YOUR KEY HERE")
///     GeneratedPluginRegistrant.register(with: self)
///     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
///   }
/// }
///
/// web
/// <head>
///   <!-- // Other stuff -->
///   <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
/// </head>
///
class MapGoogle extends Map {
  const MapGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, mapProvider, child) {
      final impl = mapProvider.impl as GoogleImpl;

      return mapProvider.latlng.isEmpty
          ? Container(color: Colors.grey[300])
          : GoogleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  mapProvider.latlng.lat,
                  mapProvider.latlng.lng,
                ),
                zoom: 18,
              ),
              markers: impl._markers,
              onMapCreated: (GoogleMapController controller) {
                impl._controller.complete(controller);
              },
            );
    });
  }
}
