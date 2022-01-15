import 'package:flutter_test/flutter_test.dart';
import 'memory.dart' as global;

void main() {
  group('[memory.global]', () {
    test('should get/set obj', () {
      var len = global.length;
      expect(global.get("key1"), isNull);
      global.set("key1", "value1");
      expect(global.get("key1"), "value1");
      expect(global.contains("key1"), true);
      var len2 = global.length;
      expect(len2 > len, true);
      global.delete("key1");
      expect(global.get("key1"), isNull);
    });

    test('should no error when delete not exists entry', () async {
      global.delete("not-exists");
    });

    test('should count key begin with A', () async {
      global.set("A1", "");
      global.set("A2", "");
      global.set("B1", "");
      expect(global.beginWith("A"), 2);
      expect(global.beginWith("B"), 1);
    });
  });
}
