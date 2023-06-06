import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// DataViewer create id list of page represent data in display
typedef DataViewer<T extends pb.Object> = Future<List<List<String>>> Function(Dataset<T> dataset);

/// Dataset keep list of row for later use
/// must implement init,refresh, more
class Dataview<T extends pb.Object> with ChangeNotifier {
  Dataview({
    required this.viewer,
    required this.dataset,
  });

  /// viewer load data from local data and return list of page
  final DataViewer<T> viewer;

  /// dataset keep data
  final Dataset<T> dataset;

  /// onMore decide how to put download rows into displayRows
  List<List<String>>? _pages;

  /// displayRows is row already in memory and ready to use
  final display = <T>[];

  /// pageIndex is current page index loaded into display
  int pageIndex = 0;

  /// totalPages return total pages
  int get totalPages => _pages?.length ?? 0;

  /// reset page index and display
  void reset() {
    pageIndex = 0;
    display.clear();
  }

  bool get hasNextPage => (pageIndex < totalPages - 1) || dataset.noMoreOnRemote == false;

  bool get _isMoreDataToLoad => pageIndex >= totalPages - 1 && dataset.noMoreOnRemote == false;

  Future<bool> _tryGetData(Dataset<T> dataset) async {
    if (pageIndex == 0) {
      await dataset.refresh();
      return true;
    } else if (_isMoreDataToLoad) {
      await dataset.more();
      return true;
    }
    return false;
  }

  /// init data view
  Future<void> init() async {
    await next();
  }

  /// live will change live mode
  Future<void> live(bool value) async {
    reset();
    dataset.live(value);
    next();
  }

  /// next load a page into display from local data
  Future<void> next() async {
    if (await _tryGetData(dataset)) {
      _pages = await viewer(dataset);
    }

    if (pageIndex < _pages!.length) {
      final page = _pages![pageIndex];
      final objects = await dataset.mapObjects(page);
      display.addAll(objects);
    }

    pageIndex++;
    notifyListeners();
  }
}
