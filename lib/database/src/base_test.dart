// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'base.dart';

void main() {
  setUpAll(() async {
    await initForTest();
  });

  setUp(() async {});

  tearDown(() async {
    await reset();
  });

  tearDownAll(() async {});

  group('[database]', () {
    test('should open/close', () async {
      final box = await openBox('test');
      await box.put('a', 'b');
      expect(box.containsKey('a'), true);
      await closeBox(box);

      // open again
      final box2 = await openBox('test');
      await box2.put('b', 'c');
      expect(box2.containsKey('a'), true);
      expect(box2.containsKey('b'), true);
      await deleteBox('test');

      // since it's been deleted, this should be a new database
      final box3 = await openBox('test');
      expect(box3.containsKey('a'), false);
      expect(box3.containsKey('b'), false);
      await deleteBox('test');
    });

    test('should reuse box', () async {
      final box1 = await openBox('test');
      final box2 = await openBox('test');
      expect(box1 == box2, true);
    });

    test('should reset', () async {
      final box = await openBox('test');
      await box.put('a', 'b');
      expect(box.containsKey('a'), true);
      await reset();

      // open again
      final box2 = await openBox('test');
      expect(box2.containsKey('a'), false);
    });
  });
}
