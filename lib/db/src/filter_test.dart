// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'filter.dart';

void main() {
  group('[filter]', () {
    test('should do full text query', () async {
      final filter = FullTextFilter('world');
      final source = sample.Person(entity: pb.Entity(id: 'helloWorld'));
      expect(filter.isMatch(source), isTrue);
      final filter2 = FullTextFilter('notExists');
      expect(filter2.isMatch(source), isFalse);
    });
  });
}
