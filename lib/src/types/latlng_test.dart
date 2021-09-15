import 'package:flutter_test/flutter_test.dart';
import 'latlng.dart';

void main() {
  group('[LatLng]', () {
    test('should return true when equal', () async {
      final l = LatLng(49.4540877, -173.7548384);
      final l2 = LatLng(49.4540877, -173.7548384);
      expect(l.equals(l2), true);
    });
    test('should return false when not equal', () async {
      final l = LatLng(49.4540877, -173.7548384);
      final l2 = LatLng(49, -173);
      expect(l.equals(l2), false);
    });
  });
}
