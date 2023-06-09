import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;

/// DataLoader is a function to load data from remote, return list of data
/// timestamp is the last time we got from remote, if null then get all data
typedef DataLoader<T extends pb.Object> = Future<List<T>> Function(
    google.Timestamp? timestamp, int rowsPerPage, int pageIndex);

/// DataFetcher fetch remote data by page, it keep track of current page index
class DataFetcher<T extends pb.Object> with ChangeNotifier {
  DataFetcher({
    required this.loader,
    this.rowsPerPage = 20,
  });

  /// noMore return true if there are no more data on remote
  bool noMore = false;

  /// hasMore return true if there are more data on remote
  bool get hasMore => !noMore;

  /// pageLength is the number of rows per page
  final int rowsPerPage;

  /// pageIndex is the current page index
  int pageIndex = 0;

  /// loader get data from remote, return data must older than timestamp
  final DataLoader<T> loader;

  void reset() {
    noMore = false;
    pageIndex = 0;
  }

  /// fetch row from remote
  Future<List<T>> fetch(google.Timestamp lastTimestamp) async {
    if (!noMore) {
      final downloadRows = await loader(lastTimestamp, rowsPerPage, pageIndex);
      if (downloadRows.isNotEmpty) {
        if (downloadRows.length < rowsPerPage) {
          noMore = true;
        }
        debugPrint('[live_data] refresh ${downloadRows.length} rows, no more=$noMore');
        pageIndex++;
        return downloadRows;
      }
    }
    return [];
  }
}
