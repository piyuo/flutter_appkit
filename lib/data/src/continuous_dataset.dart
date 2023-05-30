import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;
import 'indexed_db_provider.dart';
import 'model_index.dart';

/// _keyIndex is key for model index store in database
const _keyIndex = '_idx';

/// DataLoader can refresh or load more data by anchor and limit
/// ```dart
/// loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
///   return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
/// },
/// ```
typedef DataLoader<T> = Future<List<T>> Function(
    bool isRefresh, int limit, google.Timestamp? anchorTime, String? anchorId);

/// ContinuousDataset keep rows for later use
class ContinuousDataset<T extends pb.Object> {
  /// Dataset keep rows for later use
  /// ```dart
  /// final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
  /// await dataset.load();
  /// ```
  ContinuousDataset({
    required this.objectBuilder,
    required this.indexedDbProvider,
    required this.loader,
    int rowsPerPage = 20,
    this.sortDesc = true,
  }) {
    _modelIndex = ModelIndex(rowsPerPage: rowsPerPage);
  }

  /// _objects is list of object that is ready to use
  final _objects = <T>[];

  /// isEmpty return true if _objects is empty
  bool get isEmpty => _objects.isEmpty;

  /// length return length of _objects
  int get length => _objects.length;

  /// operator [] return object at index
  T operator [](int index) => _objects[index];

  /// selectedRows keep all selected item id
  List<String> selectedIDs = [];

  final bool sortDesc;

  /// pageIndex keep track how many page load into _data
  int pageIndex = 0;

  /// loader can refresh or load more data by anchor and limit
  final DataLoader<T> loader;

  /// objectBuilder build data
  /// ```dart
  /// objectBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> objectBuilder;

  /// indexedDbProvider is database that store data
  final IndexedDbProvider indexedDbProvider;

  /// modelIndex is index to keep track model
  late final ModelIndex _modelIndex;

  bool get hasNextPage => _modelIndex.hasNextPage(pageIndex);

  Future<void> init() async {
    final modelIndexMap = await indexedDbProvider.getJsonMap(_keyIndex);
    if (modelIndexMap != null) {
      _modelIndex.fromJsonMap(modelIndexMap);
    }
    if (_modelIndex.isNotEmpty) {
      _loadPage(0);
    }
  }

  Future<void> save() async {
    final modelIndexMap = _modelIndex.writeToJsonMap();
    await indexedDbProvider.put(_keyIndex, modelIndexMap);
  }

  /// _loadPage and set pageIndex
  Future<void> _loadPage(int index) async {
    pageIndex = index;
    final result = _modelIndex.filter(sortDesc: sortDesc, pageIndex: pageIndex).toList();
    for (final model in result) {
      final obj = await indexedDbProvider.getObject<T>(model.i, objectBuilder);
      if (obj != null) {
        _objects.add(obj);
      }
    }
  }

  Future<bool> saveDownloadRows(List<T> downloadRows) async {
    bool changed = false;
    for (final row in downloadRows) {
      if (await _modelIndex.add(row.model!)) {
        changed = true;
        await indexedDbProvider.putObject(row.id, row);
      }
    }
    return changed;
  }

  /// refresh data, return true if reset happen
  Future<void> refresh() async {
    final anchor = _modelIndex.newest;
    final downloadRows = await loader(true, _modelIndex.rowsPerPage, anchor?.t, anchor?.i);
    if (downloadRows.length == _modelIndex.rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      _modelIndex.reset();
      selectedIDs.clear();
    }

    if (downloadRows.isNotEmpty) {
      debugPrint('[data_controller] refresh ${downloadRows.length} rows');
      final changed = await saveDownloadRows(downloadRows);
      if (changed) {
        _objects.clear();
        _loadPage(0);
      }
    }
  }

  /// nextPage load next page
  Future<void> nextPage1() async {
    if (hasNextPage) {
      await _loadPage(pageIndex + 1);
    }
  }

  /// more seeking more data from data loader, return true if has more data
  /// ```dart
  /// await ds.more(testing.Context(), 2);
  /// ```
  Future<void> nextPage() async {
    if (!hasNextPage) {
      debugPrint('[data_controller] no next page');
      return;
    }

    if (_modelIndex.isMoreDataToLoad(pageIndex)) {
      final anchor = _modelIndex.oldest;
      final downloadRows = await loader(false, _modelIndex.rowsPerPage, anchor?.t, anchor?.i);
      if (downloadRows.length < _modelIndex.rowsPerPage) {
        debugPrint('[data_controller] no old data');
        _modelIndex.noOldData = true;
      }
      if (downloadRows.isNotEmpty) {
        await saveDownloadRows(downloadRows);
      }
    }

    _loadPage(pageIndex++);
  }
}
