import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;

/// ModelIndex is a tracker for model cache, it provide cutOffDate and view to help use local cache model
class ModelIndex {
  ModelIndex({
    this.onRemove,
    this.rowsPerPage = 20,
  });

  /// _list keep all model
  final _list = <pb.Model>[];

  /// _noOldData is true mean no old data in remote
  bool noOldData = true;

  /// rowsPerPage use to decide list can break into how many pages
  final int rowsPerPage;

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  bool hasNextPage(int pageIndex) => (pageIndex < totalPages - 1) || noOldData == false;

  bool isMoreDataToLoad(int pageIndex) => pageIndex >= totalPages - 1 && noOldData == false;

  /// onRemove is the callback when model is removed
  final Future<void> Function(String id)? onRemove;

  /// totalPages return total pages
  int get totalPages => (_list.length / rowsPerPage).ceil();

  /// cutOff remove all model before expired date
  Future<void> cutOff(DateTime expiredDate) async {
    List<String> needRemove = [];
    _list.removeWhere((obj) {
      final deleted = obj.t.toDateTime().isBefore(expiredDate);
      if (deleted) {
        needRemove.add(obj.i);
      }
      return deleted;
    });
    if (needRemove.isNotEmpty) {
      noOldData = false;
    }
    for (final id in needRemove) {
      await onRemove?.call(id);
    }
  }

  /// _remove remove old exists model
  Future<void> _remove(String id) async {
    _list.removeWhere((obj) => obj.i == id);
    await onRemove?.call(id);
  }

  /// add model to list, return true if it can be add
  Future<bool> add(pb.Model model) async {
    final exists = where(model.i);
    if (exists != null) {
      if (exists.t.toDateTime().isAfter(model.t.toDateTime())) {
        return false;
      }
      await _remove(model.i); // remove old model if exists. new model may have new t
    }
    _list.add(model);
    return true;
  }

  // idComparator compare two model id
  int dateComparator(pb.Model a, pb.Model b) {
    return a.t.toDateTime().compareTo(b.t.toDateTime());
  }

  /// sort by model's t
  void sort({bool desc = false}) => _list.sort((pb.Model a, pb.Model b) {
        return desc ? b.t.toDateTime().compareTo(a.t.toDateTime()) : a.t.toDateTime().compareTo(b.t.toDateTime());
      });

  /// containsKey return true if any of the key exists in cache
  bool contains(pb.Model model) {
    return _list.any((obj) => obj.i == model.i);
  }

  /// where return model by id,  null if not exists
  pb.Model? where(String id) {
    final models = _list.where((obj) => obj.i == id);
    return models.isEmpty ? null : models.first;
  }

  /// length of modeIndex
  int get length => _list.length;

  /// [] override
  pb.Model operator [](int index) => _list[index];

  /// newest model id
  pb.Model? get newest {
    sort();
    return _list.isEmpty ? null : _list.last;
  }

  /// oldest model id
  pb.Model? get oldest {
    sort();
    return _list.isEmpty ? null : _list.first;
  }

  /// oldest model date
  DateTime? get oldestDate {
    sort();
    return _list.isEmpty ? null : _list.first.t.toDateTime();
  }

  /// isOldDataAvailable return true if it may have old data in remote
  bool isOldDataAvailable(DateTime want) {
    if (noOldData) {
      return false;
    }
    final date = oldestDate;
    return date != null && (date.isAtSameMomentAs(want) || date.isAfter(want));
  }

  /// filter a subset of model base on filter condition
  Iterable<pb.Model> filter({
    bool sortDesc = true,
    DateTime? from,
    DateTime? to,
    bool skipDeleted = true,
    int pageIndex = 0,
  }) {
    sort(desc: sortDesc);
    return _list
        .where((obj) {
          if (skipDeleted && obj.d) {
            return false;
          }

          if (from != null && obj.t.toDateTime().isBefore(from)) {
            return false;
          }
          if (to != null && obj.t.toDateTime().isAfter(to)) {
            return false;
          }
          return true;
        })
        .skip(pageIndex * rowsPerPage)
        .take(rowsPerPage);
  }

  /// writeToJsonMap write ModelIndex to json map
  Map<String, dynamic> writeToJsonMap() {
    final map = <String, dynamic>{
      "0": _list.map((m) => m.writeToJsonMap()).toList(),
      "1": noOldData,
    };
    return map;
  }

  /// fromString create ModelIndex from string
  void fromJsonMap(Map<String, dynamic> map) {
    final v0 = map["0"];
    _list.clear();
    for (final item in v0) {
      _list.add(pb.Model()..mergeFromJsonMap(item));
    }
    final v1 = map["1"];
    noOldData = v1;
  }

  /// clear all model
  void clear() => _list.clear();
}
