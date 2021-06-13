class LatLng {
  LatLng(
    this.lat,
    this.lng,
  );

  final double lat;

  final double lng;

  static LatLng empty = LatLng(0, 0);

  bool get isEmpty => lat == 0;
}
