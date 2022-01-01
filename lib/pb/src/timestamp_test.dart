// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'timestamp.dart';

void main() {
  setUp(() async {});

  tearDown(() async {});

  group('[pb.timestamp]', () {
    test('should get timestamp', () async {
      final date = DateTime.utc(2021, 1, 2, 23, 30);
      final t = date.timestamp;
      final date2 = t.toDateTime();
      expect(date, date2);
    });
  });
}
