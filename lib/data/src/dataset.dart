import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/pb/src/google/google.dart' as google;
import 'dataset_snapshot.dart';

enum LoadType { refresh, more }

class LoadGuide {
  LoadGuide({
    this.anchorTimestamp,
    this.anchorId,
    this.type = LoadType.refresh,
    this.limit = 10,
  });

  google.Timestamp? anchorTimestamp;

  String? anchorId;

  // isNext set to true to load next page, otherwise load previous page
  LoadType type;

  int limit;
}

/// DataLoader load new data by guide, return null if this data reach to the end.
typedef DataLoader<T> = Future<List<T>?> Function(BuildContext context, LoadGuide guide);

class Dataset<T extends pb.Object> {
  Dataset({
    required this.dataLoader,
    required this.id,
    this.namespace = '',
  });

  final DataLoader<T> dataLoader;

  final String id;

  final String namespace;

  bool _noRefresh = false;

  bool _noMore = false;

  bool get noNeedRefresh => _noMore;

  bool get noMoreData => _noMore;

  /// _data keep all saved data
  final List<T> _data = [];

  /// init read snapshot from cache
  Future<void> init() async {
    assert(id.isNotEmpty, 'dataset id is empty');
    final snapshot = await cache.get(id);
    if (snapshot != null) {
      snapshot as DatasetSnapshot;
      for (String itemID in snapshot.data) {
        final item = await cache.get(itemID);
        _data.add(item);
      }
      _noRefresh = snapshot.noRefresh;
      _noMore = snapshot.noMore;
    }
  }

  /// saveToCache save snapshot to cache
  @visibleForTesting
  Future<void> saveToCache() async {
    assert(id.isNotEmpty, 'dataset id is empty');
    return await cache.set(
        id,
        DatasetSnapshot(
          data: _data.map((item) => item.entityId).toList(),
          noMore: _noMore,
          noRefresh: _noRefresh,
        ));
  }

  /// saveItems save list of item into cache
  @visibleForTesting
  Future<void> saveItems(List<T> items) async {
    for (var item in items) {
      await cache.set(item.entityId, item);
    }
  }

  /// deleteItems delete list of item into cache
  @visibleForTesting
  Future<void> deleteItems(List<T> items) async {
    for (var item in items) {
      await cache.delete(item.entityId);
    }
  }

  /// newGuide create guide for data loader
  @visibleForTesting
  LoadGuide newGuide(LoadType type, T? anchor, int limit) {
    return LoadGuide(
      type: type,
      anchorTimestamp: anchor != null ? anchor.getEntity()!.updateTime : null,
      anchorId: anchor != null ? anchor.getEntity()!.id : null,
      limit: limit,
    );
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
    final result = await dataLoader(context, newGuide(LoadType.refresh, anchor, limit));

    if (result == null) {
      debugPrint('[dataset] end of data, no need refresh');
      _noRefresh = true;
      return;
    }
    if (result.length == limit) {
      // if result.length == limit, it means there is more data and we need expired all our cache to start over
      _noRefresh = false;
      _noMore = false;
      await deleteItems(_data);
      _data.clear();
      debugPrint('[dataset] data reset, start fresh');
    }
    await saveItems(result);
    _data.insertAll(0, result);
    await saveToCache();
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
    final result = await dataLoader(context, newGuide(LoadType.more, anchor, limit));

    if (result == null) {
      debugPrint('[dataset] end of data, no more data');
      _noMore = true;
      return;
    }
    await saveItems(result);
    _data.addAll(result);
    if (result.length < limit) {
      _noMore = true;
    }
    await saveToCache();
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
        await cache.set(item.entityId, item);
        break;
      }
    }
    await saveToCache();
  }
}
