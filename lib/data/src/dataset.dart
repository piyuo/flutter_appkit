import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/pb/src/google/google.dart' as google;

/// deleteMaxItem is the maximum number of items to delete, rest leave to cache cleanup to avoid application busy too long.
const int deleteMaxItem = 100;

class LoadGuide {
  LoadGuide({
    required this.isRefresh,
    required this.limit,
    this.anchorTimestamp,
    this.anchorId,
  });

  /// anchorTimestamp is anchor item's timestamp
  google.Timestamp? anchorTimestamp;

  /// anchorID is anchor item's ID
  String? anchorId;

  /// isRefresh set to true mean refresh data, otherwise load more data
  bool isRefresh;

  /// limit is the number of data to load
  int limit;

  /// hasAnchor return true if the load guide has anchor
  bool get hasAnchor => anchorId != null;
}

/// DataLoader load new data by guide, return null if this data reach to the end.
typedef DataLoader<T> = Future<List<T>?> Function(BuildContext context, LoadGuide guide);

class Dataset<T extends pb.Object> {
  Dataset({
    required this.dataLoader,
    required this.id,
    this.namespace,
    this.onDataChanged,
  });

  final DataLoader<T> dataLoader;

  final String id;

  final String? namespace;

  final VoidCallback? onDataChanged;

  /// _data keep all saved data
  final List<T> _data = [];

  bool _noRefresh = false;

  bool _noMore = false;

  bool get noNeedRefresh => _noMore;

  bool get noMoreData => _noMore;

  /// init read snapshot from cache
  Future<void> init() async {
    assert(id.isNotEmpty, 'dataset id is empty');
/*
    final snapshot = await cache.get(id, namespace: namespace);
    if (snapshot == null) {
      return;
    }

    snapshot as pb.DatasetSnapshot;
    for (String itemID in snapshot.data) {
      final item = await cache.get(itemID, namespace: namespace);
      if (item == null) {
        // item should not be null, cache may not reliable
        await reset();
        return;
      }
      _data.add(item);
    }
    _noRefresh = snapshot.noRefresh;
    _noMore = snapshot.noMore;
*/
    final savedData = await cache.get('${id}_data', namespace: namespace);
    if (savedData == null) {
      return;
    }

    for (String itemID in savedData) {
      final item = await cache.get(itemID, namespace: namespace);
      if (item == null) {
        // item should not be null, cache may not reliable
        await reset();
        return;
      }
      _data.add(item);
    }
    _noRefresh = await cache.get('${id}_nr', namespace: namespace);
    _noMore = await cache.get('${id}_nm', namespace: namespace);
    onDataChanged?.call();
  }

  /// saveToCache save snapshot to cache
  @visibleForTesting
  Future<void> saveToCache() async {
    assert(id.isNotEmpty, 'dataset id is empty');
    await cache.set('${id}_data', _data.map((item) => item.entityId).toList(), namespace: namespace);
    await cache.set('${id}_nm', _noMore, namespace: namespace);
    await cache.set('${id}_nr', _noRefresh, namespace: namespace);

/*    return await cache.set(
      id,
      pb.DatasetSnapshot(
        data: _data.map((item) => item.entityId).toList(),
        noMore: _noMore,
        noRefresh: _noRefresh,
      ),
      namespace: namespace,
    );*/
  }

  /// saveItems save list of item into cache
  @visibleForTesting
  Future<void> reset() async {
    _noRefresh = false;
    _noMore = false;
    await deleteItems(_data);
    _data.clear();
    onDataChanged?.call();
    debugPrint('[dataset] data reset, start fresh');
  }

  /// saveItems save list of item into cache
  @visibleForTesting
  Future<void> saveItems(List<T> items) async {
    for (var item in items) {
      await cache.set(
        item.entityId,
        item,
        namespace: namespace,
      );
    }
  }

  /// deleteItems delete list of item from cache, max 100 items
  @visibleForTesting
  Future<void> deleteItems(List<T> items) async {
    int deleteCount = 0;
    for (var item in items) {
      await cache.delete(
        item.entityId,
        namespace: namespace,
      );
      deleteCount++;
      if (deleteCount >= deleteMaxItem) {
        break;
      }
    }
  }

  /// removeDuplicateInData remove duplicate item
  @visibleForTesting
  Future<void> removeDuplicateInData(List<T> items) async {
    final idList = items.map((item) => item.entityId).toList();
    for (int i = _data.length - 1; i >= 0; i--) {
      final item = _data[i];
      if (idList.contains(item)) {
        _data.removeAt(i);
      }
    }
  }

  /// refresh seeking new data from data loader
  Future<void> refresh(BuildContext context, int limit) async {
    if (_noRefresh) {
      debugPrint('[dataset] no refresh already');
      return;
    }

    T? anchor;
    if (_data.isNotEmpty) {
      anchor = _data.first;
    }
    final result = await dataLoader(
        context,
        LoadGuide(
          isRefresh: true,
          anchorTimestamp: anchor?.entityUpdateTime,
          anchorId: anchor?.entityId,
          limit: limit,
        ));

    if (result == null) {
      debugPrint('[dataset] end of data, no need refresh');
      _noRefresh = true;
      return;
    }
    if (result.length == limit) {
      // if result.length == limit, it means there is more data and we need expired all our cache to start over
      await reset();
    } else if (result.isNotEmpty && _data.isNotEmpty) {
      removeDuplicateInData(result);
    }

    await saveItems(result);
    _data.insertAll(0, result);
    await saveToCache();
    onDataChanged?.call();
    debugPrint('[dataset] refresh ${result.length} items');
  }

  /// more seeking more data from data loader
  Future<void> more(BuildContext context, int limit) async {
    if (_noMore) {
      debugPrint('[dataset] no more already');
      return;
    }

    T? anchor;
    if (_data.isNotEmpty) {
      anchor = _data.last;
    }
    final result = await dataLoader(
        context,
        LoadGuide(
          isRefresh: false,
          anchorTimestamp: anchor?.entityUpdateTime,
          anchorId: anchor?.entityId,
          limit: limit,
        ));
    if (result == null) {
      debugPrint('[dataset] end of data, no more data');
      _noMore = true;
      return;
    } else if (result.isNotEmpty && _data.isNotEmpty) {
      removeDuplicateInData(result);
    }
    await saveItems(result);
    _data.addAll(result);
    if (result.length < limit) {
      _noMore = true;
    }
    await saveToCache();
    onDataChanged?.call();
    debugPrint('[dataset] load ${result.length} items');
  }

  List<T> get rows => _data.where((item) => !item.entityDeleted).toList();

  int get length => rows.length;

  bool get isEmpty => rows.isEmpty;

  bool get isNotEmpty => rows.isNotEmpty;

  bool contains(T obj) => rows.contains(obj);

  /// update item in cache, usually after user edit item
  Future<void> update(T item) async {
    for (int i = 0; i < _data.length; i++) {
      if (item.entityId == _data[i].entityId) {
        _data[i] = item;
        await cache.set(item.entityId, item, namespace: namespace);
        break;
      }
    }
    await saveToCache();
  }
}
