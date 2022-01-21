import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/pb/src/google/google.dart' as google;

/// deleteMaxItem is the maximum number of items to delete, rest leave to cache cleanup to avoid application busy too long.
@visibleForTesting
int get deleteMaxItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

/// DataLoader load new data by guide, return null if this data reach to the end.
typedef DataLoader<T> = Future<List<T>?> Function(
    BuildContext context, bool refresh, int limit, google.Timestamp? anchorTime, String? anchorId);

class Dataset<T extends pb.Object> {
  Dataset({
    required this.dataLoader,
    required this.id,
    this.namespace,
    this.onDataChanged,
  });

  /// dataLoader is the function to load new data
  final DataLoader<T> dataLoader;

  /// id is the unique id of this dataset, it is used to cache data
  final String id;

  /// namespace is the namespace of this dataset, it is used to cache data
  final String? namespace;

  /// onDataChanged is the callback when data changed
  final VoidCallback? onDataChanged;

  /// _data keep all saved data
  final List<T> _data = [];

  /// _noNeedRefresh mean this dataset is no need to refresh, just use cache
  bool _noNeedRefresh = false;

  /// _noMoreData mean this dataset is no need to load more data, just use cache
  bool _noMoreData = false;

  /// noNeedRefresh set to true mean this dataset is no need to refresh, just use cache
  bool get noNeedRefresh => _noNeedRefresh;

  /// noNeedLoadMore set to true mean this dataset is no need to load more data, just use cache
  bool get noMoreData => _noMoreData;

  /// row return rows in dataset that is not deleted
  List<T> get rows => _data.where((item) => !item.entityDeleted).toList();

  /// isEmpty return rows is empty
  bool get isEmpty => rows.isEmpty;

  /// isEmpty return rows is not empty
  bool get isNotEmpty => rows.isNotEmpty;

  /// init read snapshot from cache
  Future<void> init(pb.Builder<T> builder) async {
    assert(id.isNotEmpty, 'dataset id is empty');
    final savedData = cache.getStringList(id);
    if (savedData == null) {
      return;
    }

    for (String itemID in savedData) {
      final item = cache.getObject<T>(itemID, builder);
      if (item == null) {
        // item should not be null, cache may not reliable
        await reset();
        return;
      }
      _data.add(item);
    }
    _noNeedRefresh = cache.getBool('${id}_nr') ?? false;
    _noMoreData = cache.getBool('${id}_nm') ?? false;
    onDataChanged?.call();
    debugPrint('[dataset] init $id ${_data.length}');
  }

  /// save data to cache
  @visibleForTesting
  Future<void> save() async {
    assert(id.isNotEmpty, 'dataset id is empty');
    await cache.setStringList(id, _data.map((item) => item.entityId).toList());
    await cache.setBool('${id}_nm', _noMoreData);
    await cache.setBool('${id}_nr', _noNeedRefresh);
    debugPrint('[dataset] save $id ${_data.length}');
  }

  /// saveItems save list of item into cache
  @visibleForTesting
  Future<void> reset() async {
    _noNeedRefresh = false;
    _noMoreData = false;
    await deleteItems(_data);
    _data.clear();
    onDataChanged?.call();
    debugPrint('[dataset] reset, start fresh');
  }

  /// saveItems save list of item into cache
  ///
  ///     await ds.saveItems([person]);
  ///
  @visibleForTesting
  Future<void> saveItems(List<T> items) async {
    for (var item in items) {
      await cache.setObject(
        item.entityId,
        item,
      );
    }
  }

  /// deleteItems delete list of item from cache,return actual delete count, max 100 items
  ///
  ///     await ds.deleteItems([person]);
  ///
  @visibleForTesting
  Future<int> deleteItems(List<T> items) async {
    int deleteCount = 0;
    for (var item in items) {
      await cache.delete(
        item.entityId,
      );
      deleteCount++;
      if (deleteCount >= deleteMaxItem) {
        break;
      }
    }
    return deleteCount;
  }

  /// removeDuplicateInData remove duplicate item
  ///
  ///     ds.removeDuplicateInData(samples);
  ///
  @visibleForTesting
  void removeDuplicateInData(List<T> items) {
    final idList = items.map((item) => item.entityId).toList();
    for (int i = _data.length - 1; i >= 0; i--) {
      final item = _data[i];
      if (idList.contains(item.entityId)) {
        _data.removeAt(i);
      }
    }
  }

  /// refresh seeking new data from data loader
  Future<void> refresh(BuildContext context, int limit) async {
    if (_noNeedRefresh) {
      debugPrint('[dataset] no refresh already');
      return;
    }

    T? anchor;
    if (_data.isNotEmpty) {
      anchor = _data.first;
    }
    List<T>? result;
    try {
      result = await dataLoader(context, true, limit, anchor?.entityUpdateTime, anchor?.entityId);
      if (result == null) {
        debugPrint('[dataset] end of data, no refresh');
        _noNeedRefresh = true;
        if (anchor == null) {
          debugPrint('[dataset] no anchor, no more');
          _noMoreData = true;
        }
        return;
      }
      if (result.length == limit) {
        // if result.length == limit, it means there is more data and we need expired all our cache to start over
        await reset();
      } else if (result.length < limit && anchor == null) {
        _noMoreData = true;
      }

      if (result.isNotEmpty && _data.isNotEmpty) {
        removeDuplicateInData(result);
      }

      await saveItems(result);
      _data.insertAll(0, result);
      onDataChanged?.call();
    } finally {
      await save();
      final count = result != null ? result.length : 0;
      debugPrint('[dataset] refresh $count items');
    }
  }

  /// more seeking more data from data loader
  Future<void> more(BuildContext context, int limit) async {
    if (_noMoreData) {
      debugPrint('[dataset] no more already');
      return;
    }

    T? anchor;
    if (_data.isNotEmpty) {
      anchor = _data.last;
    }
    List<T>? result;
    try {
      result = await dataLoader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityId);
      if (result == null) {
        debugPrint('[dataset] end of data, no more data');
        _noMoreData = true;
        return;
      } else if (result.isNotEmpty && _data.isNotEmpty) {
        removeDuplicateInData(result);
      }
      await saveItems(result);
      _data.addAll(result);
      if (result.length < limit) {
        _noMoreData = true;
      }
      onDataChanged?.call();
    } finally {
      await save();
      final count = result != null ? result.length : 0;
      debugPrint('[dataset] load $count items');
    }
  }

  /// set item directly to dataset,return false if no item to update, new item will move to first item in cache. usually after user edit item
  Future<void> set(T item) async {
    for (int i = 0; i < _data.length; i++) {
      if (item.entityId == _data[i].entityId) {
        _data.removeAt(i);
      }
    }
    _data.insert(0, item);
    await cache.setObject(item.entityId, item);
    await save();
  }

  /// delete item from dataset
  Future<void> delete(T item) async {
    for (int i = 0; i < _data.length; i++) {
      if (item.entityId == _data[i].entityId) {
        _data.removeAt(i);
      }
    }
    await cache.delete(item.entityId);
    await save();
  }
}
