// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'data_view.dart';
import 'paged_data_view.dart';
import 'dataset.dart';
import 'paginator.dart';

/// PagedFullView keep full data in local, no data allow to be deleted due to local cache can not detect server delete data
/// ```dart
/// final ds = PagedFullView<sample.Person>(
///   id: 'test',
///   loader: (context, _, __, anchorTimestamp, anchorId) async =>
///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
///   );
/// await ds.start(testing.Context());
/// ```
class PagedFullView<T extends net.Object> extends PagedDataView<T> {
  /// PagedFullView keep full table data in local, no data allow to be deleted due to local cache can not detect server delete data
  /// ```dart
  /// final ds = PagedFullView<sample.Person>(
  ///   id: 'test',
  ///   loader: (context, _, __, anchorTimestamp, anchorId) async =>
  ///     [sample.Person(entity: pb.Entity(id: 'duplicate'))],
  ///   );
  /// await ds.start(testing.Context());
  /// ```
  PagedFullView(
    Dataset<T> dataset, {
    BuildContext? context,
    required String id,
    required DataViewLoader<T> loader,
  }) : super(
          dataset,
          loader: loader,
        ) {
    dataset.internalNoMore = true;
  }

  /// onRefresh reset dataset, but not on full view mode
  @override
  Future<bool> onRefresh(List<T> downloadRows) async {
    await insert(downloadRows);
    return false; // table do not reset dataset
  }

  @override
  Future<void> loadMoreBeforeGotoPage(int index) async {}

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  @override
  Future<bool> more(int limit) async {
    return false;
  }

  /// hasNextPage return true if user can click next page
  @override
  bool get hasNextPage {
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    return pageIndex < paginator.pageCount - 1;
  }

  /// pagingInfo return text page info like '1-10 of 19'
  @override
  String pageInfo(BuildContext context) {
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    return '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ${context.i18n.pagingCount.replaceAll('%1', dataset.length.toString())}';
  }
}
