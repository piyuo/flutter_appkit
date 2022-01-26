import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'data.dart';
import 'data_common.dart';

/// deleteMaxItem is the maximum number of items to delete, rest leave to cache cleanup to avoid application busy too long.
@visibleForTesting
int get deleteMaxItem => kIsWeb ? 50 : 500; // web is slow, clean 50 may tak 3 sec. native is much faster

class Dataset<T extends pb.Object> extends DataCommon<T> {
  Dataset({
    required this.dataLoader,
    required pb.Builder<T> dataBuilder,
    required this.id,
    DataRemover<T>? dataRemover,
  }) : super(
          dataBuilder: dataBuilder,
          dataRemover: dataRemover,
        );

  /// id is the unique id of this dataset, it is used to cache data
  final String id;

  /// dataLoader is the function to load new data
  final DataLoader<T> dataLoader;

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
  Future<void> init(BuildContext context) async {
    assert(id.isNotEmpty, 'dataset id is empty');
    final savedData = cache.getStringList(id);
    if (savedData == null) {
      return;
    }

    for (String itemID in savedData) {
      final item = cache.getObject<T>(itemID, dataBuilder);
      if (item == null) {
        // item should not be null, cache may not reliable
        await reset();
        return;
      }
      _data.add(item);
    }
    _noNeedRefresh = cache.getBool('${id}_nr') ?? false;
    _noMoreData = cache.getBool('${id}_nm') ?? false;
    debugPrint('[dataset] init $id ${_data.length}');
  }

  /// save data to cache
  @visibleForTesting
  Future<void> save() async {
    assert(id.isNotEmpty, 'dataset id is empty');
    await cache.setStringList(id, _data.map((item) => item.entityID).toList());
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
        item.entityID,
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
        item.entityID,
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
    final idList = items.map((item) => item.entityID).toList();
    for (int i = _data.length - 1; i >= 0; i--) {
      final item = _data[i];
      if (idList.contains(item.entityID)) {
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
      result = await dataLoader(context, true, limit, anchor?.entityUpdateTime, anchor?.entityID);
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
      result = await dataLoader(context, false, limit, anchor?.entityUpdateTime, anchor?.entityID);
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
    } finally {
      await save();
      final count = result != null ? result.length : 0;
      debugPrint('[dataset] load $count items');
    }
  }

  /// delete item from dataset
  Future<void> delete(BuildContext context, List<String> ids) async {
    assert(dataRemover != null, 'dataRemover must not be null');
    await dataRemover!(context, ids);
    await setCacheDeleted(ids, builder: dataBuilder);
    for (String id in ids) {
      for (int i = 0; i < _data.length; i++) {
        if (id == _data[i].entityID) {
          _data.removeAt(i);
        }
      }
    }
    await save();
  }

  /// set item directly to dataset,return false if no item to update, new item will move to first item in cache. usually after user edit item
  @visibleForTesting
  Future<void> set(T item) async {
    for (int i = 0; i < _data.length; i++) {
      if (item.entityID == _data[i].entityID) {
        _data.removeAt(i);
      }
    }
    _data.insert(0, item);
    await cache.setObject(item.entityID, item);
    await save();
  }
}
