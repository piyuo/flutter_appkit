import 'package:flutter_test/flutter_test.dart';
import 'cache.dart' as cache;

void main() {
  group('[cache]', () {
    test('should get/set obj', () {
      var len = cache.length;
      expect(cache.get("key1"), isNull);
      cache.put("key1", "value1");
      expect(cache.get("key1"), "value1");
      expect(cache.containsKey("key1"), true);
      var len2 = cache.length;
      expect(len2 > len, true);
      cache.delete("key1");
      expect(cache.get("key1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      cache.delete("not-exists");
    });

    test('should count key begin with A', () async {
      cache.put("A1", "");
      cache.put("A2", "");
      cache.put("B1", "");
      expect(cache.beginWith("A"), 2);
      expect(cache.beginWith("B"), 1);
    });
  });
}
