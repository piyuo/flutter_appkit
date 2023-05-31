import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;
import 'indexed_db_provider.dart';
import 'model_index.dart';

/// _keyIndex is key for model index store in database
const _keyIndex = '_idx';

/// DataLoader can refresh or load more data by anchor and limit
/// ```dart
/// ```
typedef DataLoader<T> = Future<List<T>> Function(
  bool isRefresh,
  int rowsPerPage,
  google.Timestamp? anchorTime,
  String? anchorId,
);

/// ChainDataset keep rows for later use
class ChainDataset<T extends pb.Object> {
  /// ```dart
  /// final dataset = ChainDataset<sample.Person>(objectBuilder: () => sample.Person());
  /// await dataset.init();
  /// ```
  ChainDataset({
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

  /// isIdExists return true if id is exists in dataset
  bool isIdExists(String id) => _modelIndex.where(id) != null;

  Future<void> init() async {
    final modelIndexMap = await indexedDbProvider.getJsonMap(_keyIndex);
    if (modelIndexMap != null) {
      _modelIndex.fromJsonMap(modelIndexMap);
    }
    if (_modelIndex.isNotEmpty) {
      await _loadPage(0);
    }
  }

  /// save modelIndex to database
  Future<bool> _save(List<T> downloadRows) async {
    bool changed = false;
    for (final row in downloadRows) {
      if (await _modelIndex.add(row.model!)) {
        changed = true;
        await indexedDbProvider.putObject(row.id, row);
      }
    }
    if (changed) {
      final modelIndexMap = _modelIndex.writeToJsonMap();
      await indexedDbProvider.put(_keyIndex, modelIndexMap);
    }
    return changed;
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

  /// refresh data, return true if reset happen
  Future<void> refresh() async {
    final anchor = _modelIndex.newest;
    final downloadRows = await loader(
      true,
      _modelIndex.rowsPerPage,
      anchor?.t,
      anchor?.i,
    );
    if (downloadRows.length == _modelIndex.rowsPerPage) {
      // if download length == limit, it means there is more data and we need expired all our cache to start over
      _modelIndex.noOldData = false;
      _modelIndex.clear();
    } else {
      if (_modelIndex.isEmpty) {
        _modelIndex.noOldData = true;
      }
    }

    if (downloadRows.isNotEmpty) {
      debugPrint('[chain_dataset] refresh ${downloadRows.length} rows');
      bool changed = await _save(downloadRows);
      if (changed) {
        _objects.clear();
        await _loadPage(0);
      }
    }
  }

  /// nextPage load next page from data loader
  /// ```dart
  /// await ds.nextPage();
  /// ```
  Future<void> nextPage() async {
    if (!hasNextPage) {
      debugPrint('[chain_dataset] no next page');
      return;
    }

    if (_modelIndex.isMoreDataToLoad(pageIndex)) {
      final anchor = _modelIndex.oldest;
      final downloadRows = await loader(
        false,
        _modelIndex.rowsPerPage,
        anchor?.t,
        anchor?.i,
      );
      if (downloadRows.length < _modelIndex.rowsPerPage) {
        debugPrint('[chain_dataset] no old data');
        _modelIndex.noOldData = true;
      }
      if (downloadRows.isNotEmpty) {
        await _save(downloadRows);
      }
    }
    await _loadPage(++pageIndex);
  }
}
