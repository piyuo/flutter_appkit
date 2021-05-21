import 'package:flutter_test/flutter_test.dart';
import 'cache.dart' as cache;

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

    test('should remove expired entry', () async {
      cache.expiredCheck = Duration(milliseconds: 500);
      cache.set("expired1", "value1", expire: Duration(milliseconds: 400));
      await Future.delayed(Duration(milliseconds: 950));
      expect(cache.get("expired1"), isNull);
      cache.expiredCheck = const Duration(minutes: 3);
    });
  });
}
