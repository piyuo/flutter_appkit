import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'paginator.dart';
import 'data_view.dart';

/// PagedDataView is view to display paging data
class PagedDataView<T extends pb.Object> extends DataView<T> {
  PagedDataView(Dataset<T> dataset, {required DataViewLoader<T> loader}) : super(dataset, loader: loader);

  /// pageIndex is current page index
  int pageIndex = 0;

  /// load dataset
  @override
  @mustCallSuper
  Future<void> load() async {
    pageIndex = 0;
    await super.load();
  }

  /// onInsert called after insert row
  @override
  Future<void> onInsert(List<T> list) async {
    pageIndex = 0;
    await super.onInsert(list);
  }

  /// onDelete called after delete row
  @override
  Future<void> onDelete(List<String> list) async {
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    if (pageIndex >= paginator.pageCount) {
      pageIndex = paginator.pageCount - 1;
    }
    await super.onDelete(list);
  }

  /// setRowsPerPage set dataset rows per page
  @override
  Future<void> onSetRowsPerPage(int value) async {
    pageIndex = 0;
    await goto(0);
    await super.onSetRowsPerPage(value);
  }

  /// fill display rows
  /// ```dart
  /// await ds.fill();
  /// ```
  @override
  Future<void> fill() async {
    displayRows.clear();
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    final range = await dataset.range(paginator.getBeginIndex(pageIndex), paginator.getEndIndex(pageIndex));
    displayRows.addAll(range);
  }

  /// pageInfo return text page info like '1 - 10 of many'
  /// ```dart
  /// expect(ds.pageInfo(testing.Context()), '1 - 10 of many');
  /// ```
  @override
  String pageInfo(BuildContext context) {
    if (length == 0) {
      // no data to display
      return '';
    }

    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    final info = '${paginator.getBeginIndex(pageIndex) + 1} - ${paginator.getEndIndex(pageIndex)} ';
    if (noMore) {
      return info + context.i18n.pagingCount.replaceAll('%1', length.toString());
    }
    return info + context.i18n.pagingMany;
  }

  /// isFirstPage return true if it is first page
  bool get isFirstPage => pageIndex == 0;

  /// hasPrevPage return true if user can click prev page
  bool get hasPrevPage => pageIndex > 0;

  /// hasNextPage return true if user can click next page
  bool get hasNextPage {
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    return noMore ? pageIndex < paginator.pageCount - 1 : true;
  }

  /// nextPage return true if load data
  /// ```dart
  /// await nextPage(context);
  /// ```
  Future<void> nextPage() async {
    await goto(pageIndex + 1);
    await fill();
  }

  /// prevPage return true if page changed
  /// ```dart
  /// await prevPage(context);
  /// ```
  Future<void> prevPage() async {
    await goto(pageIndex - 1);
    await fill();
  }

  /// goto specified page, load more page if needed
  /// ```dart
  /// await goto(context, 2);
  /// ```
  Future<void> goto(int index) async {
    await loadMoreBeforeGotoPage(index);
    final paginator = Paginator(rowCount: dataset.length, rowsPerPage: dataset.rowsPerPage);
    pageIndex = index;
    if (pageIndex < 0) {
      pageIndex = 0;
    }
    if (pageIndex >= paginator.pageCount) {
      pageIndex = paginator.pageCount - 1;
    }
  }

  /// loadMoreBeforeGotoPage load more data before goto page
  Future<void> loadMoreBeforeGotoPage(int index) async {
    final expectRowsCount = length - index * rowsPerPage;
    if (expectRowsCount < rowsPerPage && !noMore) {
      //the page is not fill with enough data, load more data
      await more(rowsPerPage - expectRowsCount);
    }
  }
}
