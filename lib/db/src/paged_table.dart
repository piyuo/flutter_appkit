// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'dataset.dart';
import 'paged_dataset.dart';
import 'memory.dart';
import 'paginator.dart';

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
class PagedTable<T extends pb.Object> extends PagedDataset<T> {
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
  PagedTable(
    Memory<T> _memory, {
    BuildContext? context,
    required String id,
    required pb.Builder<T> dataBuilder,
    required DatasetLoader<T> loader,
  }) : super(
          _memory,
          context: context,
          dataBuilder: dataBuilder,
          loader: loader,
        ) {
    _memory.noMoreData = true;
  }

  /// onRefresh reset memory on dataset mode, but not on table mode
  @override
  Future<void> onRefresh(BuildContext context, List<T> downloadRows) async {
    await memory.insert(downloadRows);
    await gotoPage(context, 0);
  }

  @override
  Future<void> loadMoreBeforeGotoPage(BuildContext context, int index) async {}

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

  /// pagingInfo return text page info like '1-10 of 19'
  @override
  String information(BuildContext context) {
    final paginator = Paginator(rowCount: innerMemory.length, rowsPerPage: innerMemory.rowsPerPage);
    return '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ' +
        context.i18n.pagingCount.replaceAll('%1', innerMemory.length.toString());
  }
}
