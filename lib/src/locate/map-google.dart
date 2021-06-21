import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:libcli/identifier.dart' as identifier;
import 'map.dart';

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
  MapGoogle(
    MapValueController controller, {
    Key? key,
  }) : super(controller, key: key);

  @override
  State<MapGoogle> createState() => MapGoogleState();
}

class MapGoogleState extends State<MapGoogle> {
  Completer<GoogleMapController> _googleController = Completer();

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
            markerId: MarkerId(identifier.uuid()), // marker id must be unique
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
    final GoogleMapController futureController = await _googleController.future;
    futureController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(l.lat, l.lng),
      zoom: 18,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.controller.value.latlng;
    return l.isEmpty
        ? Container(color: Colors.grey[300])
        : GoogleMap(
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                l.lat,
                l.lng,
              ),
              zoom: 18,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _googleController.complete(controller);
            },
          );
  }
}
