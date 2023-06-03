import 'package:libcli/pb/pb.dart' as pb;
import 'package:meta/meta.dart';
import 'indexed_db_provider.dart';
import 'model_index.dart';

/// _keyIndex is key for model index store in database
const _keyIndex = '_idx';

/// Dataset keep list of row for later use
/// must implement init,refresh, more
abstract class Dataset<T extends pb.Object> {
  Dataset({
    required this.objectBuilder,
    required this.db,
    this.cutOffDays = 180,
  }) {
    index = ModelIndex(onRemove: onModelRemoved);
  }

  /// _cacheMode is true will use indexed db to cache data
  bool _cacheMode = true;

  /// cacheMode is true will use indexed db to cache data
  bool get cacheMode => _cacheMode;

  /// setCacheMode will change cache mode
  Future<void> setCacheMode(bool value) async {
    _noMoreOnRemote = true;
    _cacheMode = value;
    onCacheModeChanged(_cacheMode);
  }

  /// _noMoreOnRemote use only in no cache mode
  bool _noMoreOnRemote = true;

  /// noMoreOnRemote return true mean no more data on remote
  bool get noMoreOnRemote => _cacheMode ? index.noMoreOnRemote : _noMoreOnRemote;

  /// cutOffDays is how many days to keep data in dataset
  final int cutOffDays;

  /// objectBuilder build data
  /// ```dart
  /// objectBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> objectBuilder;

  /// displayRows is row already in memory and ready to use
  final displayRows = <T>[];

  /// db is indexed db that store data
  final IndexedDbProvider db;

  /// modelIndex is index to keep track model
  late final ModelIndex index;

  /// isEmpty return true if displayRows is empty
  bool get isEmpty => displayRows.isEmpty;

  /// length return length of displayRows
  int get length => displayRows.length;

  /// operator [] return object at index
  T operator [](int index) => displayRows[index];

  /// getDisplayRowById return display row by id
  T? getDisplayRowById(String id) => displayRows.where((obj) => obj.id == id).firstOrNull;

  /// isIdExists return true if id is exists in dataset
  bool isIdExists(String id) => index.getModelById(id) != null;

  /// saveIndexToDb save modelIndex to database
  Future<void> saveIndexToDb() async {
    final indexMap = index.writeToJsonMap();
    await db.put(_keyIndex, indexMap);
  }

  /// saveDownloadRows save download rows and changed index to database
  Future<bool> saveDownloadRows(List<T> downloadRows) async {
    updateDisplayRows(downloadRows);
    removeDeletedRows();
    bool changed = false;
    for (final row in downloadRows) {
      if (await index.add(row.model!)) {
        changed = true;
        await db.putObject(row.id, row);
      }
    }
    if (changed) {
      await saveIndexToDb();
    }
    return changed;
  }

  /// removeDeletedRows remove deleted rows from _rows list
  void removeDeletedRows() {
    for (int i = displayRows.length - 1; i >= 0; i--) {
      final row = displayRows[i];
      if (row.deleted) {
        displayRows.removeAt(i);
      }
    }
  }

  /// updateDisplayRows update download rows in _rows list, replace old row with new row
  void updateDisplayRows(List<T> downloadRows) {
    for (T row in downloadRows) {
      final index = displayRows.indexWhere((obj) => obj.id == row.id);
      if (index != -1) {
        final other = displayRows[index];
        if (row.lastUpdateTime.toDateTime().isAfter(other.lastUpdateTime.toDateTime())) {
          displayRows[index] = row;
        }
      }
    }
  }

  /// _cutOff remove all data before expiredDate, it will called by refresh
  Future<void> _cutOff() async {
    if (cutOffDays > 0) {
      final expiredDate = DateTime.now().add(Duration(days: -cutOffDays));
      final removeAny = await index.cutOff(expiredDate.toUtc());
      if (removeAny) {
        await saveIndexToDb();
      }
    }
  }

  /// init load data from database and remove old data use cutOffDays
  @mustBeOverridden
  Future<void> init() async {
    final indexMap = await db.getJsonMap(_keyIndex);

    if (indexMap != null) {
      index.fromJsonMap(indexMap);
    }
    if (index.isNotEmpty) {
      await _cutOff();
    }
  }

  /// onModelAdded is call when new model is removed
  Future<void> onModelRemoved(String id) async {
    await db.delete(id);
  }

  /// refresh to get new rows
  Future<void> refresh();

  /// more to load more old rows
  Future<void> more();

  /// more to load more old rows
  Future<void> onCacheModeChanged(bool cacheMode);
}
