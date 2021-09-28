import 'package:flutter_test/flutter_test.dart';
import 'registry.dart';

void main() {
  group('[registry]', () {
    test('should to/from json', () {
      var now = DateTime(2001, 11, 12, 13, 00, 00).toUtc();
      Registry r = Registry(
        key: '1',
        size: 256,
        expired: now,
      );
      final map = r.toJsonMap();
      final r2 = Registry.fromJson(map!);
      expect(r.size, 256);
      expect(r.storageKey, isNotEmpty);
      expect(r.key, r2.key);
      expect(r.size, r2.size);
      expect(r.expired, r2.expired);
    });
  });
}
