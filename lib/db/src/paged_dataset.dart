import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';
import 'paginator.dart';
import 'dataset.dart';

/// PagedDataset is dataset that support page
class PagedDataset<T extends pb.Object> extends Dataset<T> {
  PagedDataset(
    Memory<T> _memory, {
    BuildContext? context,
    required DatasetLoader<T> loader,
    required pb.Builder<T> dataBuilder,
    VoidCallback? onReady,
    Future<void> Function(BuildContext context)? onChanged,
  }) : super(
          _memory,
          context: context,
          loader: loader,
          dataBuilder: dataBuilder,
          onReady: onReady,
          onChanged: onChanged,
        );

  /// pageIndex is current page index
  int pageIndex = 0;

  /// onRefresh reset memory on dataset mode, but not on table mode, return true if reset memory
  @override
  Future<bool> onRefresh(BuildContext context, List<T> downloadRows) async {
    final isReset = await super.onRefresh(context, downloadRows);
    await gotoPage(context, 0);
    return isReset;
  }

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  @override
  void fill() {
    displayRows.clear();
    final paginator = Paginator(rowCount: memory.length, rowsPerPage: memory.rowsPerPage);
    final range = memory.range(paginator.getBeginIndex(pageIndex), paginator.getEndIndex(pageIndex));
    displayRows.addAll(range);
  }

  /// pageInfo return text page info like '1 - 10 of many'
  /// ```dart
  /// expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
  /// ```
  @override
  String pageInfo(BuildContext context) {
    final paginator = Paginator(rowCount: memory.length, rowsPerPage: memory.rowsPerPage);
    final info = '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ';
    if (noMore) {
      return info + context.i18n.pagingCount.replaceAll('%1', length.toString());
    }
    return info + context.i18n.pagingMany;
  }

  /// gotoPage goto specified page, load more page if needed
  /// ```dart
  /// await gotoPage(context, 2);
  /// ```
  Future<void> gotoPage(BuildContext context, int index) async {
    await loadMoreBeforeGotoPage(context, index);
    try {
      final paginator = Paginator(rowCount: memory.length, rowsPerPage: memory.rowsPerPage);
      pageIndex = index;
      if (pageIndex < 0) {
        pageIndex = 0;
      }
      if (pageIndex >= paginator.pageCount) {
        pageIndex = paginator.pageCount - 1;
      }
      fill();
    } finally {
      notifyListeners();
    }
  }

  /// isFirstPage return true if it is first page
  bool get isFirstPage => pageIndex == 0;

  /// hasPrevPage return true if user can click prev page
  bool get hasPrevPage => pageIndex > 0;

  /// hasNextPage return true if user can click next page
  bool get hasNextPage {
    final paginator = Paginator(rowCount: memory.length, rowsPerPage: memory.rowsPerPage);
    return noMore ? pageIndex < paginator.pageCount - 1 : true;
  }

  /// nextPage return true if load data
  ///
  ///     await nextPage(context);
  ///
  Future<void> nextPage(BuildContext context) async => await gotoPage(context, pageIndex + 1);

  /// prevPage return true if page changed
  ///
  ///     await prevPage();
  ///
  Future<void> prevPage(BuildContext context) async => await gotoPage(context, pageIndex - 1);

  /// loadMoreBeforeGotoPage load more data before goto page
  Future<void> loadMoreBeforeGotoPage(BuildContext context, int index) async {
    final expectRowsCount = length - index * rowsPerPage;
    if (expectRowsCount < rowsPerPage && !noMore) {
      //the page is not fill with enough data, load more data
      await more(context, rowsPerPage - expectRowsCount);
    }
  }

  /// setRowsPerPage set rows per page and change page index to 0
  /// ```dart
  /// await setRowsPerPage(context, 20);
  /// ```
  @override
  Future<void> setRowsPerPage(BuildContext context, int value) async {
    pageIndex = 0;
    await memory.setRowsPerPage(context, value);
    await gotoPage(context, 0);
    notifyListeners();
  }
}
