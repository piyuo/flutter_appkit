// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'dataset.dart';

void main() {
  setUpAll(() async {
    await db.initForTest({'sample': sample.objectBuilder});
    await cache.initForTest();
  });

  setUp(() async {
    await cache.reset();
  });

  group('[dataset]', () {
    test('should init', () async {
      Dataset ds = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      expect(ds.rows.isEmpty, true);
      expect(ds.isEmpty, true);
      expect(ds.rows.isNotEmpty, false);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);

      await ds.init();
      expect(ds.noMoreData, false);
      expect(ds.noNeedRefresh, false);
      expect(ds.rows.isEmpty, true);
    });

    test('should reset', () async {
      Dataset ds = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            List.generate(
                limit,
                (i) => sample.Person(
                      entity: pb.Entity(
                        id: i.toString(),
                      ),
                    )),
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.rows.length, 1);
      expect(cache.contains('0'), true);

      await ds.reset();
      expect(cache.contains('0'), false);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.isEmpty, true);
    });

    test('should save and delete items', () async {
      Dataset ds = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            null,
      );
      final person = sample.Person(
          entity: pb.Entity(
            id: 'personId',
          ),
          name: 'hi',
          age: 2);

      expect(cache.contains('personId'), false);
      await ds.saveItems([person]);
      expect(cache.contains('personId'), true);
      final delCount = await ds.deleteItems([person]);
      expect(delCount, 1);
      expect(cache.contains('personId'), false);
    });

    test('should not delete after max item limit', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            null,
      );
      final samples = List.generate(
          deleteMaxItem + 1,
          (i) => sample.Person(
                entity: pb.Entity(
                  id: i.toString(),
                ),
              ));
      await ds.saveItems(samples);
      expect(cache.contains('0'), true);
      expect(cache.contains(deleteMaxItem.toString()), true);
      final delCount = await ds.deleteItems(samples);
      expect(delCount, deleteMaxItem);
      expect(cache.contains('0'), false);
      //only delete max item, so there is one item left
      expect(cache.contains(deleteMaxItem.toString()), true);
    });

    test('should set no refresh, no more when data loader return nothing', () async {
      bool refreshed = false;
      int refreshLimit = 0;
      Dataset ds = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          refreshed = true;
          refreshLimit = limit;
          return null;
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 9);
      expect(refreshed, true);
      expect(refreshLimit, 9);
      expect(ds.noNeedRefresh, true);
      expect(ds.noMoreData, true);

      // check cache
      final ds2 = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      await ds2.init();
      expect(ds2.noNeedRefresh, true);
      expect(ds2.noMoreData, true);
      expect(ds2.rows.length, 0);
    });

    test('should keep refresh, more and reset when receive enough data', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: index.toString(),
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 2);
      // second refresh will trigger reset
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 2);
    });

    test('should keep refresh, more and cache when receive less data', () async {
      int refreshCount = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                      ),
                    ));
          }
          return List.generate(
              1,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: 'refresh' + index.toString(),
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 2);
      // second refresh will trigger reset
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 3);

      // check cache
      final ds2 = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      await ds2.init();
      expect(ds2.noNeedRefresh, false);
      expect(ds2.noMoreData, false);
      expect(ds2.rows.length, 3);
    });

    test('should remove duplicate data', () async {
      final samples = [
        sample.Person(
          entity: pb.Entity(
            id: 'duplicate',
          ),
        )
      ];
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            samples,
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.rows.length, 1);

      // second refresh will trigger reset
      ds.removeDuplicateInData(samples);
      expect(ds.rows.length, 0);
    });

    test('should remove duplicate data in cache when refresh', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            [
          sample.Person(
            entity: pb.Entity(
              id: 'duplicate',
            ),
          )
        ],
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 1);
      // second refresh will trigger reset
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 1);
    });

    test('should keep more and cache when receive enough data', () async {
      int refreshCount = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                      ),
                    ));
          }
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: 'more' + index.toString(),
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 2);
      expect(ds.noMoreData, false);
      // second refresh will trigger reset
      await ds.more(testing.Context(), 2);
      expect(ds.noMoreData, false);
      expect(ds.rows.length, 4);

      // check cache
      final ds2 = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      await ds2.init();
      expect(ds2.noNeedRefresh, false);
      expect(ds2.noMoreData, false);
      expect(ds2.rows.length, 4);
    });

    test('should no keep more when receive less data', () async {
      int refreshCount = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                      ),
                    ));
          }
          return List.generate(
              1,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: 'more' + index.toString(),
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 2);
      expect(ds.noNeedRefresh, false);
      expect(ds.noMoreData, false);
      // second refresh will trigger reset
      await ds.more(testing.Context(), 2);
      expect(ds.noMoreData, true);
      expect(ds.rows.length, 3);

      // check cache
      final ds2 = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      await ds2.init();
      expect(ds2.noMoreData, true);
      expect(ds2.rows.length, 3);
    });

    test('should update cache', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: index.toString(),
                    ),
                    name: index.toString(),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 2);
      expect(ds.rows[1].name, '1');
      expect(ds.rows[1].entityId, '1');

      final person = sample.Person(
        entity: pb.Entity(
          id: '1',
        ),
        name: 'new name',
      );
      await ds.set(person);

      // check cache
      final ds2 = Dataset(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return null;
        },
      );
      await ds2.init();
      expect(ds.rows[0].name, 'new name');
      expect(ds.rows[0].entityId, '1');
    });

    test('should delete cache', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            null,
      );
      final person = sample.Person(
        entity: pb.Entity(
          id: '1',
        ),
        name: 'new name',
      );
      await ds.set(person);
      expect(ds.rows.length, 1);
      await ds.delete(person);
      expect(ds.rows.length, 0);
    });

    test('should send anchor to data loader', () async {
      int idCount = 0;
      bool? _isRefresh;
      int? _limit;
      google.Timestamp? _anchorTimestamp;
      String? _anchorId;

      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          _isRefresh = isRefresh;
          _limit = limit;
          _anchorTimestamp = anchorTimestamp;
          _anchorId = anchorId;
          idCount++;
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: idCount.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(_isRefresh, true);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNull);
      expect(_anchorId, isNull);

      await ds.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');

      await ds.more(testing.Context(), 1);
      expect(_isRefresh, false);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '2');

      await ds.refresh(testing.Context(), 1);
      expect(_isRefresh, true);
      expect(_limit, 1);
      expect(_anchorTimestamp, isNotNull);
      expect(_anchorId, '1');
    });

    test('should no refresh', () async {
      int refreshCount = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          refreshCount++;
          return null;
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.noNeedRefresh, true);
      expect(refreshCount, 1);

      await ds.refresh(testing.Context(), 1);
      expect(ds.noNeedRefresh, true);
      expect(refreshCount, 1);

      await ds.refresh(testing.Context(), 1);
      expect(ds.noNeedRefresh, true);
      expect(refreshCount, 1);
    });

    test('should no more on null', () async {
      int moreCount = 0;
      int counter = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          if (counter == 0) {
            counter++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                        updateTime: DateTime.now().utcTimestamp,
                      ),
                    ));
          }
          moreCount++;
          return null;
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.noMoreData, false);

      await ds.more(testing.Context(), 1);
      expect(ds.noMoreData, true);
      expect(moreCount, 1);

      await ds.more(testing.Context(), 1);
      expect(ds.noMoreData, true);
      expect(moreCount, 1);
    });

    test('should no more on less data', () async {
      int moreCount = 0;
      int counter = 0;
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          if (counter == 0) {
            counter++;
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: index.toString(),
                        updateTime: DateTime.now().utcTimestamp,
                      ),
                    ));
          }
          moreCount++;
          return List.generate(
              1,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: index.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 1);
      expect(ds.noMoreData, false);

      await ds.more(testing.Context(), 2);
      expect(ds.noMoreData, true);
      expect(moreCount, 1);

      await ds.more(testing.Context(), 2);
      expect(ds.noMoreData, true);
      expect(moreCount, 1);
    });

    test('should not return deleted rows', () async {
      final ds = Dataset<sample.Person>(
        id: 'testId',
        dataLoader: (
          context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async {
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: index.toString(),
                      updateTime: DateTime.now().utcTimestamp,
                    ),
                  ));
        },
      );
      await ds.init();
      await ds.refresh(testing.Context(), 5);
      expect(ds.rows.length, 5);

      final row0 = ds.rows[0];
      row0.entity.deleted = true;

      expect(ds.rows.length, 4);
    });
  });
}
