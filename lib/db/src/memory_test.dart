// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/testing/testing.dart' as testing;
import 'memory_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[memory]', () {
    test('should count page row', () async {
      final memory = MemoryRam(dataBuilder: () => sample.Person());
      expect(memory.internalNoMore, false);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 0);
      expect(memory.isEmpty, true);
      expect(memory.isNotEmpty, false);
      memory.add(testing.Context(), [sample.Person()]);
      expect(memory.internalNoMore, false);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 1);
      expect(memory.isEmpty, false);
      expect(memory.isNotEmpty, true);
    });

    test('should call onChanged when update data', () async {
      bool changed = false;
      final memory = MemoryRam(
        dataBuilder: () => sample.Person(),
        onChanged: () => changed = true,
      );

      await memory.insert(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.add(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.delete(testing.Context(), [sample.Person()]);
      expect(changed, true);

      changed = false;
      await memory.clear(testing.Context());
      expect(changed, true);

      changed = false;
      await memory.clear(testing.Context());
      expect(changed, true);

      changed = false;
      await memory.update(testing.Context(), sample.Person());
      expect(changed, true);
    });
  });
}
