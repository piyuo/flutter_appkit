import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;
import 'dataset.dart';

/// DatasetByRowLoader used in [DatasetByRow] can refresh or load more data by anchor and limit
/// ```dart
/// ```
typedef DatasetByRowLoader<T> = Future<List<T>> Function(bool isRefresh, int rowCount, google.Timestamp? timestamp);

/// DatasetByRow load data by row
class DatasetByRow<T extends pb.Object> extends Dataset<T> {
  /// ```dart
  /// final dataset = ChainDataset<sample.Person>(objectBuilder: () => sample.Person());
  /// await dataset.init();
  /// ```
  DatasetByRow({
    required this.loader,
    this.sortFromOldToNew = true,
    this.rowsPerPage = 20,
    required super.db,
    required super.objectBuilder,
    super.cutOffDays = 180,
  });

  final bool sortFromOldToNew;

  /// rowsPerPage use to decide list can break into how many pages
  final int rowsPerPage;

  /// pageIndex keep track how many page load into _data
  int pageIndex = 0;

  bool get hasNextPage => (pageIndex < totalPages - 1) || index.noMoreOnRemote == false;

  bool isMoreDataToLoad(int pageIndex) => pageIndex >= totalPages - 1 && index.noMoreOnRemote == false;

  /// totalPages return total pages
  int get totalPages => (displayRows.length / rowsPerPage).ceil();

  /// loader can refresh or load more data by anchor and limit
  final DatasetByRowLoader<T> loader;

  /// init load data from database and remove old data use cutOffDays
  @override
  Future<void> init() async {
    await super.init();
    if (index.isNotEmpty) {
      await _loadPage(0);
    }
  }

  /// onCacheModeChanged will be called when cache mode change
  @override
  Future<void> onCacheModeChanged(bool cacheMode) async {
    if (cacheMode) {
      displayRows.clear();
      pageIndex = 0;
      await _loadPage(0);
      return;
    }
    displayRows.clear();
  }

  /// _loadPage and set pageIndex
  Future<void> _loadPage(int newPageIndex) async {
    pageIndex = newPageIndex;
    final result =
        index.filter(sortFromOldToNew: sortFromOldToNew, start: pageIndex * rowsPerPage, length: rowsPerPage);
    for (final model in result) {
      final obj = await db.getObject<T>(model.i, objectBuilder);
      if (obj != null) {
        displayRows.add(obj);
      }
    }
  }

  /// refreshByCache refresh data by using cache
  Future<void> refreshByCache() async {
    final anchor = index.newest;
    final downloadRows = await loader(true, rowsPerPage, anchor?.t);

    // if download length < limit, it means there is no more data
    if (downloadRows.length < rowsPerPage && index.isEmpty) {
      index.noMoreOnRemote = true;
      await saveIndexToDb();
      debugPrint('[dataset] no old data');
    }

    if (downloadRows.isNotEmpty) {
      if (downloadRows.length == rowsPerPage) {
        // if download length == limit, it means there is more data and we need expired all our cache to start over
        index.noMoreOnRemote = false;
        await index.clear();
        await saveIndexToDb();
        debugPrint('[dataset] reset');
      }

      debugPrint('[chain_dataset] refresh ${downloadRows.length} rows');
      bool changed = await saveDownloadRows(downloadRows);
      if (changed) {
        displayRows.clear();
        pageIndex = 0;
        await _loadPage(0);
      }
    }
  }

  /// refreshNoCache refresh data by not using cache
  Future<void> refreshNoCache() async {
    final anchor = index.newest;
    final downloadRows = await loader(true, rowsPerPage, anchor?.t);

    if (downloadRows.isNotEmpty) {
      if (downloadRows.length == rowsPerPage) {
        // if download length == limit, it means there is more data and we need expired all our cache to start over
        index.noMoreOnRemote = false;
        await index.clear();
        await saveIndexToDb();
        debugPrint('[dataset] reset');
      }

      debugPrint('[chain_dataset] refresh ${downloadRows.length} rows');
      bool changed = await saveDownloadRows(downloadRows);
      if (changed) {
        displayRows.clear();
        pageIndex = 0;
        await _loadPage(0);
      }
    }
  }

  /// refresh data, return true if reset happen
  @override
  Future<void> refresh() async {
    if (cacheMode) {
      await refreshByCache();
      return;
    }
    await refreshNoCache();
  }

  /// more load more from data loader
  /// ```dart
  /// await ds.more();
  /// ```
  @override
  Future<void> more() async {
    if (!hasNextPage) {
      debugPrint('[dataset] no next page');
      return;
    }

    if (isMoreDataToLoad(pageIndex)) {
      final anchor = index.oldest;
      final downloadRows = await loader(false, rowsPerPage, anchor?.t);
      if (downloadRows.isNotEmpty) {
        if (downloadRows.length < rowsPerPage) {
          debugPrint('[dataset] no old data');
          index.noMoreOnRemote = true;
        }
        await saveDownloadRows(downloadRows);
      }
    }
    await _loadPage(++pageIndex);
  }
}
