import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';
import 'data_fetcher.dart';

/// DataViewer create id list of page represent data in display
typedef DataViewer<T extends pb.Object> = Future<List<List<String>>> Function(Dataset<T> dataset);

/// Dataset keep list of row for later use
/// must implement init,refresh, more
class Dataview<T extends pb.Object> with ChangeNotifier {
  Dataview({
    required this.viewer,
    required this.dataset,
    required this.fetcher,
  });

  /// viewer load data from local data and return list of page
  final DataViewer<T> viewer;

  /// dataset keep data
  final Dataset<T> dataset;

  /// fetcher fetch data from remote
  final DataFetcher<T> fetcher;

  /// onMore decide how to put download rows into displayRows
  List<List<String>>? _pages;

  /// _display is row already in memory and ready to use
  final _display = <T>[];

  /// _pageIndex is current page index loaded into display
  int _pageIndex = 0;

  /// totalPages return total pages
  int get totalPages => _pages?.length ?? 0;

  /// hasMore return true when current page is last page and dataset did not have full data
  bool get hasMore => (_pageIndex == totalPages - 1) == false && dataset.hasMore && fetcher.hasMore;

  /// noMore return true when no more data on remote
  bool get noMore => !hasMore;

  /// hasNextPage return true if there is more page to load
  bool get hasNextPage => (_pageIndex < totalPages - 1) == false;

  /// init data view
  Future<void> init() async {
    await dataset.init();
    await refresh();
  }

  /// refresh dataset
  Future<void> refresh() async {
    await dataset.refresh();
    await create();
  }

  /// create a new view from dataset
  Future<void> create() async {
    _pageIndex = 0;
    _display.clear();
    _pages = await viewer(dataset);
    await next();
  }

  /// next load a page into display from local data
  Future<void> next() async {
    if (_pageIndex < _pages!.length) {
      final page = _pages![_pageIndex];
      final objects = await dataset.mapObjects(page);
      _display.addAll(objects);
    }

    _pageIndex++;
    notifyListeners();
  }

  /// _getFetchTimestamp return timestamp to fetch data
  google.Timestamp? _getFetchTimestamp() {
    if (!hasMore) {
      return null;
    }
    if (_display.isNotEmpty) {
      return _display.last.timestamp;
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

      final rows = await fetcher.fetch(lastTimestamp);
      if (rows.isNotEmpty) {
        _display.addAll(rows);
        notifyListeners();
      }
    }
  }
}
