// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'filter.dart';

void main() {
  group('[filter]', () {
    test('should do full text query', () async {
      final filter = FullTextFilter('world');
      final source = sample.Person()..id = 'helloWorld';
      expect(filter.isMatch(source), isTrue);
      final filter2 = FullTextFilter('notExists');
      expect(filter2.isMatch(source), isFalse);
    });
  });
}
