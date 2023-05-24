import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'ram_provider.dart';

void main() {
  group('[cache.ram_provider]', () {
    test('should get/set', () {
      RamProvider cache = RamProvider();
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

    test('should use pb.object as key', () {
      final cache = RamProvider();
      final key = pb.Error()..code = 'err1';
      var len = cache.length;
      expect(cache.get(key), isNull);
      cache.put(key, "value1");
      expect(cache.get(key), "value1");
      expect(cache.containsKey(key), true);

      final key2 = pb.Error()..code = 'err1';
      expect(cache.get(key2), "value1");
      expect(cache.containsKey(key2), true);

      var len2 = cache.length;
      expect(len2 > len, true);
      cache.delete(key);
      expect(cache.get(key), isNull);

      expect(cache.get(key2), isNull);
      expect(cache.containsKey(key2), false);
    });

    test('should remove expired entry', () async {
      RamProvider cache = RamProvider(
        expiredCheck: const Duration(milliseconds: 500),
      );
      cache.put("expired1", "value1", expire: const Duration(milliseconds: 400));
      await Future.delayed(const Duration(milliseconds: 950));
      expect(cache.get("expired1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      RamProvider cache = RamProvider();
      cache.delete("not-exists");
    });

    test('should remove first entry when cache is full', () async {
      RamProvider cache = RamProvider();
      for (var i = 0; i <= cache.maxCacheLimit + 10; i++) {
        cache.put('$i', "");
      }
      expect(cache.length, cache.maxCacheLimit);
    });

    test('should count key begin with A', () async {
      RamProvider cache = RamProvider();
      cache.put("A1", "");
      cache.put("A2", "");
      cache.put("B1", "");
      expect(cache.beginWith("A"), 2);
      expect(cache.beginWith("B"), 1);
    });
  });
}
