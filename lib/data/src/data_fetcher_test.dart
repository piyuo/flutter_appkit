// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'data_fetcher.dart';

void main() {
  group('[data.data_fetcher]', () {
    test('should fetch data', () async {
      int fetchCount = 0;

      final df = DataFetcher<sample.Person>(
        rowsPerPage: 10,
        loader: (timestamp, rowsPerPage, pageIndex) async {
          fetchCount++;
          return [
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          ];
        },
      );
      final result = await df.fetch(DateTime(2023, 06, 15).utcTimestamp);
      expect(result.length, 1);
      expect(result[0].id, '1');
      // no more is true when download rows count < rowsPerPage
      expect(df.noMore, isTrue);
      expect(df.pageIndex, 1);
      expect(fetchCount, 1);

      fetchCount = 0;
      // should not fetch when no more
      final result2 = await df.fetch(DateTime(2023, 06, 15).utcTimestamp);
      expect(result2, isEmpty);
      expect(fetchCount, 0);
      expect(df.pageIndex, 1);
    });

    test('should change page index when fetch', () async {
      int fetchIndex = 0;

      final df = DataFetcher<sample.Person>(
        rowsPerPage: 1,
        loader: (timestamp, rowsPerPage, pageIndex) async {
          fetchIndex = pageIndex;
          return [
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          ];
        },
      );
      final result = await df.fetch(DateTime(2023, 06, 15).utcTimestamp);
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(df.noMore, isFalse); // still have more data when download rows count == rowsPerPage
      expect(df.pageIndex, 1);
      expect(fetchIndex, 0);

      final result2 = await df.fetch(DateTime(2023, 06, 15).utcTimestamp);
      expect(result2, isNotEmpty);
      expect(fetchIndex, 1);
      expect(df.pageIndex, 2);
    });

    test('should reset pageIndex and noMore', () async {
      final df = DataFetcher<sample.Person>(
        rowsPerPage: 10,
        loader: (timestamp, rowsPerPage, pageIndex) async {
          return [
            sample.Person(m: pb.Model(i: '1', t: DateTime(2021, 1, 1).utcTimestamp)),
          ];
        },
      );
      final result = await df.fetch(DateTime(2023, 06, 15).utcTimestamp);
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(df.noMore, isTrue);
      expect(df.pageIndex, 1);

      df.reset();
      expect(df.noMore, isFalse);
      expect(df.pageIndex, 0);
    });
  });
}
