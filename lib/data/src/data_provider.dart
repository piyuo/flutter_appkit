import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:provider/provider.dart';
import 'dataset.dart';
import 'data_fetcher.dart';
import 'change_finder.dart';

/// DataProvider read data from dataset user viewer to create list of page
class DataProvider<T extends pb.Object> with ChangeNotifier {
  DataProvider({
    required this.dataset,
    this.fetcher,
  }) : assert(fetcher != null);

  /// dataset keep data
  final Dataset<T> dataset;

  /// fetcher only fetch data you want display to user (e.g. after filter/sort), these fetch data will not save to dataset
  final DataFetcher<T>? fetcher;

  /// _fetchRows keep rows that fetcher load from remote
  List<T>? _fetchRows;

  /// displayRows is rows already in memory and ready to use
  final displayRows = <T>[];

  /// hasMore return true when current page is last page and dataset did not have full data
  bool get hasMore => dataset.hasMore && fetcher != null && fetcher!.hasMore;

  /// noMore return true when no more data on remote
  bool get noMore => !hasMore;

  /// isNotFilledPage return true when available rows can not fill a page and can fetch more
  bool get isNotFilledPage => fetcher != null && displayRows.length < fetcher!.rowsPerPage;

  /// of get DatabaseProvider from context
  static DataProvider<T> of<T extends pb.Object>(BuildContext context) {
    return Provider.of<DataProvider<T>>(context, listen: false);
  }

  /// init data view
  Future<void> init() async {
    await dataset.init();
    await refresh();
  }

  /// dispose database
  @override
  void dispose() {
    _fetchRows = null;
    displayRows.clear();
    dataset.dispose();
    super.dispose();
  }

  /// restart clean displayRows start from beginning, you should reload if user change filter/sort
  Future<void> restart({bool notify = true}) async {
    _fetchRows = null;
    fetcher?.reset();
    await _reload(notify);
  }

  /// refresh load new data data from remote
  Future<ChangeFinder<T>?> refresh({bool findDifference = false, bool notify = true}) async {
    Future<void> refreshData() async {
      final downloadRows = await dataset.refresh();
      if (_fetchRows != null) {
        for (T row in downloadRows) {
          _fetchRows!.removeWhere((t) => t.id == row.id);
        }
      }
      await _reload(notify);
    }

    if (findDifference) {
      final backup = List<T>.from(displayRows);
      await refreshData();
      final changeFinder = ChangeFinder<T>();
      changeFinder.refreshDifference(source: backup, target: displayRows);
      return changeFinder;
    }
    await refreshData();
    return null;
  }

  /// _reload will build display rows,
  Future<void> _reload(bool notify) async {
    displayRows.clear();
    displayRows.addAll(dataset.select());
    if (_fetchRows != null) {
      displayRows.addAll(_fetchRows!); // add fetchRows make sure more() work correctly
    } else if (isNotFilledPage && hasMore) {
      // when _fetchRows is null, we may need to fetch more data
      await more();
    }
    notifyListeners();
  }

  /// more fetch more data from remote, return true if load more data
  Future<bool> more({bool notify = true}) async {
    if (hasMore) {
      final lastTimestamp = _getFetchTimestamp();
      if (lastTimestamp == null) {
        return false;
      }

      final rows = await fetcher!.fetch(lastTimestamp);
      if (rows.isNotEmpty) {
        if (_fetchRows == null) {
          _fetchRows = rows;
        } else {
          _fetchRows!.addAll(rows);
        }
        displayRows.addAll(rows);
        if (notify) {
          notifyListeners();
        }
        return true;
      }
    }
    return false;
  }

  /// _getFetchTimestamp return timestamp to fetch data
  google.Timestamp? _getFetchTimestamp() {
    if (!hasMore) {
      return null;
    }
    final rows = displayRows;
    if (rows.isNotEmpty) {
      return rows.last.timestamp;
    }
    return dataset.utcExpiredDate!.timestamp;
  }
}
