import 'package:flutter/widgets.dart';
import 'package:libcli/types.dart' as types;

class Place {
  Place({
    required this.address,
    required this.latlng,
    required this.tags,
  });

  final String address;

  final types.LatLng latlng;

  final List<String> tags;

  static Place empty = Place(
    address: "",
    latlng: types.LatLng.empty,
    tags: [],
  );

  bool get isEmpty => latlng.isEmpty;
}

class PlaceController extends ValueNotifier<Place> {
  PlaceController({Place? value}) : super(value ?? Place.empty);
}
