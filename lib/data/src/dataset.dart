import 'package:flutter/material.dart';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'dart:math';
import 'indexed_db.dart';

/// DataRefresher is a function to load data from remote, return list of data
typedef DataRefresher<T extends pb.Object> = Future<List<T>> Function(google.Timestamp? timestamp);

/// Dataset keep list of row for later use
class Dataset<T extends pb.Object> {
  Dataset({
    required this.refresher,
    required this.indexedDb,
    required this.builder,
    this.utcExpiredDate,
  });

  /// _rows keep all rows in db, it will load by init
  final _rows = <T>[];

  /// utcExpiredDate is the utc date line to remove data
  DateTime? utcExpiredDate;

  /// hasMore return true if there are more data on remote
  bool get hasMore => utcExpiredDate != null;

  /// refresher get data from remote, return data must newer than timestamp
  final DataRefresher<T> refresher;

  /// indexedDb is indexed db that store all object
  final IndexedDb indexedDb;

  /// builder is builder to build object
  final pb.Builder<T> builder;

  /// rows return all rows
  List<T> get rows => _rows;

  /// init load data from database and remove old data use cutOffDays
  Future<void> init() async {
    await indexedDb.init();
    for (final key in indexedDb.keys) {
      final row = await indexedDb.getObject<T>(key, builder);
      if (row != null) {
        _rows.add(row);
      }
    }
    pb.Object.sort(_rows);

    // no need to remove expired every time, 1/10 chance to remove is enough
    if (Random().nextInt(10) == 1) {
      await removeExpired();
    }
  }

  /// dispose database
  @mustCallSuper
  void dispose() {
    indexedDb.dispose();
  }

  /// removeExpired remove all data that is not in keep duration
  Future<void> removeExpired() async {
    if (utcExpiredDate != null) {
      List<String> needRemove = [];
      _rows.removeWhere((row) {
        final deleted = row.timestamp.toDateTime().isBefore(utcExpiredDate!);
        if (deleted) {
          needRemove.add(row.id);
        }
        return deleted;
      });
      if (needRemove.isNotEmpty) {
        for (final id in needRemove) {
          await indexedDb.delete(id);
        }
      }
    }
  }

  /// refreshTimestamp return timestamp to refresh data
  google.Timestamp? get refreshTimestamp {
    if (_rows.isNotEmpty) {
      return _rows.first.timestamp;
    }

    if (utcExpiredDate != null) {
      return utcExpiredDate!.timestamp;
    }

    return null;
  }

  /// refresh to get new rows
  Future<void> refresh() async {
    final downloadRows = await refresher(refreshTimestamp);
    if (downloadRows.isNotEmpty) {
      debugPrint('[dataset] refresh ${downloadRows.length} rows');
      for (final row in downloadRows) {
        await _addRow(row);
      }
      pb.Object.sort(_rows);
    }
  }

  /// _addRow put row into db and check if it is newer than existing row
  Future<void> _addRow(T row) async {
    final exists = getRowById(row.id);
    if (exists != null) {
      if (exists.timestamp.toDateTime().isAfter(row.timestamp.toDateTime()) ||
          exists.timestamp.toDateTime().isAtSameMomentAs(row.timestamp.toDateTime())) {
        return;
      }
      _rows.remove(exists);
    }
    _rows.insert(0, row);
    await indexedDb.putObject(row.id, row);
  }

  /// getRowById return row by id, null if not exists
  T? getRowById(String id) => _rows.where((row) => row.id == id).firstOrNull;

  /// [] override to get field value
  operator [](String key) => getRowById(key);

  /// query return list of object that match query
  Iterable<T> query({
    bool skipDeleted = true,
    String? keyword,
    DateTime? from,
    DateTime? to,
    int? start,
    int? length,
    bool Function(T row)? filter,
  }) {
    var result = _rows.where((row) {
      if (skipDeleted && row.deleted) {
        return false;
      }

      if (from != null && (row.timestamp.toDateTime().isBefore(from.toUtc()))) {
        return false;
      }
      if (to != null && (row.timestamp.toDateTime().isAfter(to.toUtc()))) {
        return false;
      }
      if (keyword != null && !row.toString().toLowerCase().contains(keyword.toLowerCase())) {
        return false;
      }

      if (filter != null) {
        return filter(row);
      }

      return true;
    });
    if (start != null) {
      result = result.skip(start);
    }
    if (length != null) {
      result = result.take(length);
    }

    return result;
  }

  /// mapObjects return list of object that match given id
  /*List<T> mapObjects(Iterable<String> list) {
    final objects = <T>[];
    for (final id in list) {
      final object = getRowById(id);
      if (object != null) {
        objects.add(object);
      }
    }
    return objects;
  }*/
}
