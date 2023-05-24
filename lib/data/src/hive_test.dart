// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'hive.dart';

void main() {
  setUp(() async {});

  group('[cache.hive]', () {
    test('should open/close', () async {
      final box = await openBox('testOpen');
      await box.put('a', 'b');
      expect(box.containsKey('a'), true);
      await closeBox(box);

      // open again
      final box2 = await openBox('testOpen');
      await box2.put('b', 'c');
      expect(box2.containsKey('a'), true);
      expect(box2.containsKey('b'), true);
      await deleteBox(box2);

      // since it's been deleted, this should be a new database
      final box3 = await openBox('testOpen');
      expect(box3.containsKey('a'), false);
      expect(box3.containsKey('b'), false);
      await deleteBox(box3);
    });

    test('should reuse box', () async {
      final box1 = await openBox('testReuse');
      final box2 = await openBox('testReuse');
      expect(box1 == box2, true);
    });

    test('should reset box', () async {
      final box = await openBox('testReset');
      await box.put('a', 'b');
      expect(box.containsKey('a'), true);
      await resetBox(box);

      // open again
      final box2 = await openBox('testReset');
      expect(box2.containsKey('a'), false);
    });
  });
}
