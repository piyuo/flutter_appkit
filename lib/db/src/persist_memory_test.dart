// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/testing/testing.dart' as testing;
import 'memory_database.dart';
import 'db.dart';

void main() {
  setUpAll(() async {
    await initDBForTest();
  });

  setUp(() async {
    await deleteMemoryDatabase('test');
  });

  tearDownAll(() async {
    await deleteMemoryDatabase('test');
  });

  group('[persist_memory]', () {
    test('should broadcast when save', () async {
      final memory = MemoryDatabase<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await memory.open();
      expect(memory.length, 0);

      final memory2 = MemoryDatabase<sample.Person>(name: 'test', dataBuilder: () => sample.Person());
      await memory2.open();
      await memory2.add(testing.Context(), [sample.Person(name: 'hi')]);

      expect(memory.length, 1);
    });
  });
}
