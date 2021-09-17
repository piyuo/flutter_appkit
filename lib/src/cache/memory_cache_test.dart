import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/cache/memory_cache.dart';

void main() {
  group('[memory-cache]', () {
    test('should get/set obj', () {
      MemoryCache cache = MemoryCache();
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
      MemoryCache cache = MemoryCache(
        expiredCheck: const Duration(milliseconds: 500),
      );
      cache.set("expired1", "value1", expire: const Duration(milliseconds: 400));
      await Future.delayed(const Duration(milliseconds: 950));
      expect(cache.get("expired1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      MemoryCache cache = MemoryCache();
      cache.delete("not-exists");
    });

    test('should remove first entry when cache is full', () async {
      MemoryCache cache = MemoryCache();
      for (var i = 0; i <= cache.maxCacheLimit + 10; i++) {
        cache.set('$i', "");
      }
      expect(cache.length, cache.maxCacheLimit);
    });

    test('should count key begin with A', () async {
      MemoryCache cache = MemoryCache();
      cache.set("A1", "");
      cache.set("A2", "");
      cache.set("B1", "");
      expect(cache.beginWith("A"), 2);
      expect(cache.beginWith("B"), 1);
    });
  });
}
