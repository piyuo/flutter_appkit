// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'dataset.dart';
import 'db.dart';
import 'memory_database.dart';
import 'paginator.dart';

/// deleteTable delete table database
/// ```dart
/// await deleteTable('test');
/// ```
Future<void> deleteTable(String id) async => deleteDatabase(id);

/// Table keep full table data in local, no data allow to be deleted due to local cache can not detect server delete data
/// ```dart
/// final ds = Table<sample.Person>(
///   id: 'test',
///   dataBuilder: () => sample.Person(),
///   loader: (context, _, __, anchorTimestamp, anchorId) async =>
///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
///   );
/// await ds.start(testing.Context());
/// ```
class Table<T extends pb.Object> extends Dataset<T> {
  /// Table keep full table data in local, no data allow to be deleted due to local cache can not detect server delete data
  /// ```dart
  /// final ds = Table<sample.Person>(
  ///   id: 'test',
  ///   dataBuilder: () => sample.Person(),
  ///   loader: (context, _, __, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  ///   );
  /// await ds.start(testing.Context());
  /// ```
  Table({
    BuildContext? context,
    required String id,
    required pb.Builder<T> dataBuilder,
    required DatasetLoader<T> loader,
  }) : super(
          MemoryDatabase(id: id, dataBuilder: dataBuilder),
          context: context,
          dataBuilder: dataBuilder,
          loader: loader,
        );

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  @override
  Future<bool> more(BuildContext context, int limit) async {
    return false;
  }

  /// hasNextPage return true if user can click next page
  @override
  bool get hasNextPage {
    final paginator = Paginator(rowCount: innerMemory.length, rowsPerPage: innerMemory.rowsPerPage);
    return pageIndex < paginator.pageCount - 1;
  }

  @override
  Future<void> loadMoreBeforeGotoPage(BuildContext context, int index) async {}

  /// pagingInfo return text page info like '1-10 of 19'
  @override
  String pagingInfo(BuildContext context) {
    final paginator = Paginator(rowCount: innerMemory.length, rowsPerPage: innerMemory.rowsPerPage);
    return '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ' +
        context.i18n.pagingCount.replaceAll('%1', innerMemory.length.toString());
  }

  /// onBeforeRefresh called before refresh
  @override
  void onBeforeRefresh(List<T> list) {}
}
