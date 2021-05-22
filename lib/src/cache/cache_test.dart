import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/cache/cache.dart' as cache;

void main() {
  group('[cache]', () {
    test('should get/set obj', () {
      var len = cache.length;
      expect(cache.get("key1"), isNull);
      cache.set("key1", "value1");
      expect(cache.get("key1"), "value1");
      expect(cache.contains("key1"), true);
      var len2 = cache.length;
      expect(len2 > len, true);
      cache.delete("key1");
      expect(cache.get("key1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      cache.delete("not-exists");
    });

    test('should count key begin with A', () async {
      cache.set("A1", "");
      cache.set("A2", "");
      cache.set("B1", "");
      expect(cache.beginWith("A"), 2);
      expect(cache.beginWith("B"), 1);
    });
  });
}
