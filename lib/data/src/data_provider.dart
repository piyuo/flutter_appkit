import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:provider/provider.dart';
import 'dataset.dart';
import 'data_fetcher.dart';

/// DataSelector select data from dataset
typedef DataSelector<T extends pb.Object> = List<T> Function(Dataset<T> dataset);

/// DataProvider read data from dataset user viewer to create list of page
class DataProvider<T extends pb.Object> with ChangeNotifier {
  DataProvider({
    required this.selector,
    required this.dataset,
    this.fetcher,
  });

  /// dataset keep data
  final Dataset<T> dataset;

  /// selector only select data you want display to user (e.g. after filter/sort)
  final DataSelector<T> selector;

  /// fetcher only fetch data you want display to user (e.g. after filter/sort), these fetch data will not save to dataset
  final DataFetcher<T>? fetcher;

  /// displayRows is rows already in memory and ready to use
  final displayRows = <T>[];

  /// hasMore return true when current page is last page and dataset did not have full data
  bool get hasMore => dataset.hasMore && fetcher != null && fetcher!.hasMore;

  /// noMore return true when no more data on remote
  bool get noMore => !hasMore;

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
    displayRows.clear();
    displayRows.addAll(selector(dataset));
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
