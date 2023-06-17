// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'change_finder.dart';

void main() {
  group('[data.change_finder]', () {
    test('should find refresh difference', () async {
      final finder = ChangeFinder();

      finder.refreshDifference(source: [
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 2).utcTimestamp)),
        sample.Person(m: pb.Model(i: '3', t: DateTime(2021, 1, 3).utcTimestamp)),
      ], target: [
        sample.Person(m: pb.Model(i: '4', t: DateTime(2021, 1, 1).utcTimestamp)),
        sample.Person(m: pb.Model(i: '2', t: DateTime(2021, 1, 3).utcTimestamp)),
        sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
      ]);

      expect(finder.isChanged, true);

      expect(finder.insertCount, 2);
      expect(finder.removed.length, 2);

      // 2 changed, consider as removed
      expect(finder.removed[1], isNotNull);
      expect(finder.removed[1]!.id, '2');

      // 3 has been removed
      expect(finder.removed[2], isNotNull);
      expect(finder.removed[2]!.id, '3');
    });
  });
}
