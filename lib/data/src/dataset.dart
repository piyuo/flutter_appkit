import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'local.dart';
import 'local_memory.dart';

/// DataLoader load data from remote base on timestamp on local
/// return list of data and noMoreOnRemote
typedef DataLoader<T extends pb.Object> = Future<(List<T>, bool)> Function(google.Timestamp? timestamp);

/// Dataset keep list of row for later use
/// must implement init,refresh, more
class Dataset<T extends pb.Object> with ChangeNotifier {
  Dataset({
    required this.local,
    required this.refreshData,
    this.moreData,
  });

  /// refreshData refresh data from remote base on newest timestamp on local
  final DataLoader<T> refreshData;

  /// moreData load more data from remote base on oldest timestamp on local
  final DataLoader<T>? moreData;

  /// local keep data in local
  Local<T> local;

  /// _liveMode is true will use memory to show data on live, it will not cached data in local db
  bool _liveMode = true;

  /// backupLocal backup local data when live mode is on
  Local<T>? backupLocal;

  /// noMoreOnRemote is true if no more data on remote
  bool get noMoreOnRemote => local.isNoMoreOnRemote();

  /// getDisplayRowById return display row by id
  //T? getDisplayRowById(String id) => display.where((obj) => obj.id == id).firstOrNull;

  /// getObjectById return object by id, null if not exists
  Future<T?> getObjectById(String id) async => await local.getObjectById(id);

  /// removeDeletedRows remove deleted rows from _rows list
  /*
  void removeDeletedRows() {
    for (int i = display.length - 1; i >= 0; i--) {
      final row = display[i];
      if (row.deleted) {
        display.removeAt(i);
      }
    }
  }

  /// updateDisplayRows update download rows in _rows list, replace old row with new row
  void updateDisplayRows(List<T> downloadRows) {
    for (T row in downloadRows) {
      final index = display.indexWhere((obj) => obj.id == row.id);
      if (index != -1) {
        final other = display[index];
        if (row.lastUpdateTime.toDateTime().isAfter(other.lastUpdateTime.toDateTime())) {
          display[index] = row;
        }
      }
    }
  }
*/
  /// init load data from database and remove old data use cutOffDays
  Future<void> init() async {
    await local.init();
  }

  /// dispose close local data
  @override
  void dispose() {
    local.dispose();
    super.dispose();
  }

  /// live will change live mode
  Future<void> live(bool value) async {
    _liveMode = value;
    if (_liveMode) {
      backupLocal = local;
      local = LocalMemory();
    } else {
      local = backupLocal!;
      backupLocal = null;
    }
  }

  /// refresh to get new rows
  Future<void> refresh() async {
    final (downloadRows, noMoreOnRemote) = await refreshData(local.getNewestTime());
    if (downloadRows.isNotEmpty) {
      debugPrint('[dataset] refresh ${downloadRows.length} rows, noMore: $noMoreOnRemote');
      await local.add(downloadRows, noMoreOnRemote);
    }
  }

  /// more load more old rows
  Future<void> more() async {
    if (local.isNoMoreOnRemote()) {
      return;
    }
    final (downloadRows, noMoreOnRemote) = await moreData!(local.getOldestTime());
    if (downloadRows.isNotEmpty) {
      debugPrint('[dataset] more ${downloadRows.length} rows, noMore: $noMoreOnRemote');
      await local.add(downloadRows, noMoreOnRemote);
    }
  }

  /// query return list of model that match query
  Future<Iterable<pb.Model>> query({
    bool sortNewestFirst = true,
    bool skipDeleted = true,
    DateTime? from,
    DateTime? to,
    int start = 0,
    int length = 0,
  }) =>
      local.query(
        sortNewestFirst: sortNewestFirst,
        skipDeleted: skipDeleted,
        from: from,
        to: to,
        start: start,
        length: length,
      );

  /// mapObjects return list of object that match given id
  Future<List<T>> mapObjects(Iterable<String> list) async {
    final objects = <T>[];
    for (final id in list) {
      final object = await local.getObjectById(id);
      if (object != null) {
        objects.add(object);
      }
    }
    return objects;
  }
}
