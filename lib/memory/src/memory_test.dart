import 'package:flutter_test/flutter_test.dart';
import 'memory.dart';

void main() {
  group('[memory]', () {
    test('should get/set obj', () {
      Memory cache = Memory();
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
      Memory cache = Memory(
        expiredCheck: const Duration(milliseconds: 500),
      );
      cache.set("expired1", "value1", expire: const Duration(milliseconds: 400));
      await Future.delayed(const Duration(milliseconds: 950));
      expect(cache.get("expired1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      Memory cache = Memory();
      cache.delete("not-exists");
    });

    test('should remove first entry when cache is full', () async {
      Memory cache = Memory();
      for (var i = 0; i <= cache.maxCacheLimit + 10; i++) {
        cache.set('$i', "");
      }
      expect(cache.length, cache.maxCacheLimit);
    });

    test('should count key begin with A', () async {
      Memory cache = Memory();
      cache.set("A1", "");
      cache.set("A2", "");
      cache.set("B1", "");
      expect(cache.beginWith("A"), 2);
      expect(cache.beginWith("B"), 1);
    });
  });
}
