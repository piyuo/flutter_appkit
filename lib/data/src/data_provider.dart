import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:provider/provider.dart';
import 'dataset.dart';
import 'data_fetcher.dart';

/// DataViewer create id list of page represent data in display
typedef DataViewer<T extends pb.Object> = List<List<String>> Function(Dataset<T> dataset);

/// DataProvider read data from dataset user viewer to create list of page
class DataProvider<T extends pb.Object> with ChangeNotifier {
  DataProvider({
    required this.viewer,
    required this.dataset,
    this.fetcher,
  });

  /// viewer load data from local data and return list of page
  final DataViewer<T> viewer;

  /// dataset keep data
  final Dataset<T> dataset;

  /// fetcher fetch data from remote
  final DataFetcher<T>? fetcher;

  /// onMore decide how to put download rows into displayRows
  List<List<String>>? _pages;

  /// displayRows is rows already in memory and ready to use
  final displayRows = <T>[];

  /// _pageIndex is current page index loaded into display
  int _pageIndex = 0;

  /// totalPages return total pages
  int get totalPages => _pages?.length ?? 0;

  /// pageIndex return current page index
  int get pageIndex => _pageIndex;

  /// hasMore return true when current page is last page and dataset did not have full data
  bool get hasMore => noNextPage && dataset.hasMore && fetcher != null && fetcher!.hasMore;

  /// noMore return true when no more data on remote
  bool get noMore => !hasMore;

  /// hasNextPage return true if there is more page to load
  bool get hasNextPage => _pageIndex < totalPages - 1;

  /// noNextPage return true if no next page
  bool get noNextPage => !hasNextPage;

  /// isEnd return true if no more data on remote and no more page to load
  bool get isEnd => noMore && noNextPage;

  /// of get DatabaseProvider from context
  static DataProvider of(BuildContext context) {
    return Provider.of<DataProvider>(context, listen: false);
  }

  /// init data view
  Future<void> init() async {
    await dataset.init();
  }

  /// dispose database
  @override
  void dispose() {
    displayRows.clear();
    dataset.dispose();
    super.dispose();
  }

  /// refresh dataset
  Future<void> refresh() async {
    await dataset.refresh();
    begin();
  }

  /// begin a new view from dataset
  void begin() {
    _pageIndex = 0;
    displayRows.clear();
    _pages = viewer(dataset);
    _fill();
  }

  /// _fill load a page into display from local data
  void _fill() {
    if (_pageIndex < _pages!.length) {
      final page = _pages![_pageIndex];
      final objects = dataset.mapObjects(page);
      displayRows.addAll(objects);
    }
  }

  /// nextPage load a page into display from local data
  void nextPage() {
    _pageIndex++;
    _fill();
    notifyListeners();
  }

  /// _getFetchTimestamp return timestamp to fetch data
  google.Timestamp? _getFetchTimestamp() {
    if (!hasMore) {
      return null;
    }
    if (displayRows.isNotEmpty) {
      return displayRows.last.timestamp;
    }
    return dataset.utcExpiredDate!.timestamp;
  }

  /// fetch more data from remote
  Future<void> more() async {
    if (hasMore) {
      final lastTimestamp = _getFetchTimestamp();
      if (lastTimestamp == null) {
        return;
      }

      final rows = await fetcher!.fetch(lastTimestamp);
      if (rows.isNotEmpty) {
        displayRows.addAll(rows);
        notifyListeners();
      }
    }
  }
}
