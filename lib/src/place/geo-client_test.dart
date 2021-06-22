import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/env.dart' as env;
import 'package:libcli/mocking.dart' as mocking;
import 'package:libcli/types.dart' as types;
import 'geo-client.dart';

void main() {
  setUp(() async {
    env.init(env.BRANCH_MASTER);
  });

  group('[geo-client]', () {
    test('should return empty list when no input in auto complete', () async {
      final geoClient = GeoClient();
      final list = await geoClient.autoComplete(mocking.Context(), '', types.LatLng.empty);
      expect(list, isEmpty);
    });

    test('should return auto complete suggestions', () async {
      final geoClient = GeoClient();
      final suggestions =
          await geoClient.autoComplete(mocking.Context(), '165', types.LatLng(33.7338518, -117.7403496));
      expect(suggestions, isNotEmpty);
      final suggestion = suggestions[0];
      expect(suggestion.id, isNotEmpty);
      expect(suggestion.text, isNotEmpty);

      final location = await geoClient.getLocation(mocking.Context(), suggestion.id);
      expect(location!.address, isNotEmpty);
    });

    test('should return reverse geocoding location list', () async {
      final geoClient = GeoClient();
      final locations = await geoClient.reverseGeocoding(mocking.Context(), types.LatLng(33.7338518, -117.7403496));
      expect(locations, isNotEmpty);
    });
  });
}
