import 'dart:math';
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/pb/pb.dart' as pb;
import 'indexed_provider_db.dart';

/// DataSelector select data from dataset
typedef DataSelector<T extends pb.Object> = Iterable<T> Function(Dataset<T> dataset);

/// DataRefresher is a function to load data from remote, return list of data
//typedef DataRefresher<T extends pb.Object> = Future<List<T>> Function(google.Timestamp? timestamp);

/// Dataset keep list of row for later use
class Dataset<T extends pb.Object> {
  Dataset({
    required this.builder,
    this.utcExpiredDate,
  });

  /// _rows keep all rows in db, it will load by init
  final _rows = <T>[];

  /// utcExpiredDate is the utc date line to remove data
  DateTime? utcExpiredDate;

  /// hasMore return true if there are more data on remote
  bool get hasMore => utcExpiredDate != null;

  /// indexedDbProvider is a [IndexedDbProvider] that store all object, if null mean do not store data
  IndexedDbProvider? _indexedDbProvider;

  /// builder is builder to build object
  final pb.Builder<T> builder;

  /// rows return all rows
  List<T> get rows => _rows;

  /// init load data from database and remove old data use cutOffDays
  Future<void> init({
    IndexedDbProvider? indexedDbProvider,
  }) async {
    _indexedDbProvider = indexedDbProvider;
    if (_indexedDbProvider == null) {
      return;
    }
    for (final key in _indexedDbProvider!.keys) {
      final row = await _indexedDbProvider!.getRow<T>(key, builder);
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

      if (_indexedDbProvider != null && needRemove.isNotEmpty) {
        for (final id in needRemove) {
          await _indexedDbProvider!.removeRow(id);
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

  /// insertRows insert list of rows to dataset, replace old row if it's already exist
  Future<void> insertRows(List<T> rows) async {
    for (final row in rows) {
      await _insertRow(row);
    }
    pb.Object.sort(_rows);
  }

  /// insertRow insert row to dataset, replace old row if it's already exist
  Future<void> insertRow(T row) async {
    await _insertRow(row);
    pb.Object.sort(_rows);
  }

  /// _insertRow insert row to dataset, replace old row if it's already exist
  Future<void> _insertRow(T row) async {
    final exists = getRowById(row.id);
    if (exists != null) {
      if (exists.timestamp.toDateTime().isAfter(row.timestamp.toDateTime()) ||
          exists.timestamp.toDateTime().isAtSameMomentAs(row.timestamp.toDateTime())) {
        return;
      }
      _rows.remove(exists);
    }
    _rows.insert(0, row);
    if (_indexedDbProvider != null) {
      await _indexedDbProvider!.addRow(row.id, row);
    }
  }

  /// removeRow remove row from dataset
  Future<void> removeRow(T row) async {
    final exists = getRowById(row.id);
    if (exists != null) {
      _rows.remove(exists);
      if (_indexedDbProvider != null) {
        await _indexedDbProvider!.removeRow(row.id);
      }
    }
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
}
