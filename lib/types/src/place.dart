import 'latlng.dart';

/// Place is geographic location
class Place {
  Place({
    required this.address,
    required this.latlng,
    required this.tags,
    required this.country,
  });

  /// address is official address, but not contain floor or room
  final String address;

  // latlng is this place coordinate
  final LatLng latlng;

  /// tags is a list of tag about this place like 'SPECTRUM', 'IRVINE', 'CA', 'US'
  final List<String> tags;

  /// country code like 'US', 'CN', 'AU'
  final String country;

  /// empty instance of place
  static Place empty = Place(
    address: '',
    latlng: LatLng.empty,
    tags: [],
    country: '',
  );

  /// isEmpty return true if this place is empty
  bool get isEmpty => latlng.isEmpty;
}
