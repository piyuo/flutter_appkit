/// Latlng represent latitude and longitude
///
class LatLng {
  LatLng(
    this.lat,
    this.lng,
  );

  final double lat;

  final double lng;

  static LatLng empty = LatLng(0, 0);

  bool get isEmpty => lat == 0;

  /// equals return true if value is equal
  bool equals(LatLng value) {
    return lat == value.lat && lng == value.lng;
  }
}
