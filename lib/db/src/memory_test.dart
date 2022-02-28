// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'memory_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  tearDownAll(() async {});

  group('[memory]', () {
    test('should count page row', () async {
      final memory = MemoryRam(dataBuilder: () => sample.Person());
      expect(memory.noMoreData, false);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 0);
      expect(memory.isEmpty, true);
      expect(memory.isNotEmpty, false);
      memory.add([sample.Person()]);
      expect(memory.noMoreData, false);
      expect(memory.rowsPerPage, 10);
      expect(memory.length, 1);
      expect(memory.isEmpty, false);
      expect(memory.isNotEmpty, true);
    });
  });
}
