import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;

/// ModelIndex is a tracker for model cache, it provide cutOffDate and view to help use local cache model
class ModelIndex {
  ModelIndex({
    this.onRemove,
  });

  /// _list keep all model
  final _list = <pb.Model>[];

  /// noMoreOnRemote is true mean no more data on remote
  bool noMoreOnRemote = true;

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  /// onRemove is the callback when model is removed
  final Future<void> Function(String id)? onRemove;

  /// cutOff remove all model before expired date, return true if any model is removed
  Future<bool> cutOff(DateTime expiredDate) async {
    List<String> needRemove = [];
    _list.removeWhere((obj) {
      final deleted = obj.t.toDateTime().isBefore(expiredDate);
      if (deleted) {
        needRemove.add(obj.i);
      }
      return deleted;
    });
    if (needRemove.isNotEmpty) {
      noMoreOnRemote = false;
    }
    for (final id in needRemove) {
      await onRemove?.call(id);
    }
    return needRemove.isNotEmpty;
  }

  /// add objects to index, call callback if it is new object
  Future<void> add(List<pb.Object> rows, {Future<void> Function(pb.Object)? callback}) async {
    for (final row in rows) {
      if (await addModel(row.model!)) {
        await callback?.call(row);
      }
    }
    sort();
  }

  /// addModel add model to list, return true if it can be add
  Future<bool> addModel(pb.Model model) async {
    final exists = getModelById(model.i);
    if (exists != null) {
      if (exists.t.toDateTime().isAfter(model.t.toDateTime())) {
        return false;
      }
      _list.remove(exists);
    }
    _list.add(model);
    return true;
  }

  /// newestFirstComparator compare two model by t date, newest first
  int newestFirstComparator(pb.Model a, pb.Model b) {
    return b.t.toDateTime().compareTo(a.t.toDateTime());
  }

  /// oldestFirstComparator compare two model by t date, oldest first
  int oldestFirstComparator(pb.Model a, pb.Model b) {
    return a.t.toDateTime().compareTo(b.t.toDateTime());
  }

  /// sort by model's t date, from old to new
  void sort({sortNewestFirst = true}) => _list.sort(sortNewestFirst ? newestFirstComparator : oldestFirstComparator);

  /// getModelById return model by id, null if not exists
  pb.Model? getModelById(String id) {
    return _list.where((obj) => obj.i == id).firstOrNull;
  }

  /// length of modeIndex
  int get length => _list.length;

  /// [] override
  pb.Model operator [](int index) => _list[index];

  /// newest model id
  pb.Model? get newest {
    return _list.isEmpty ? null : _list.first;
  }

  /// oldest model id
  pb.Model? get oldest {
    return _list.isEmpty ? null : _list.last;
  }

  /// oldest model date
  DateTime? get oldestDate {
    return _list.isEmpty ? null : _list.last.t.toDateTime();
  }

  /// isOldDataAvailable return true if it may have old data in remote
  bool isOldDataAvailable(DateTime want) {
    if (noMoreOnRemote) {
      return false;
    }
    final date = oldestDate;
    return date != null && (date.isAtSameMomentAs(want) || date.isAfter(want));
  }

  /// query return list of model that match query
  Iterable<pb.Model> query({
    bool sortNewestFirst = true,
    DateTime? from,
    DateTime? to,
    bool skipDeleted = true,
    int start = 0,
    int length = 0,
  }) {
    var list = _list.where((obj) {
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
    });
    if (!sortNewestFirst) {
      var temp = list.toList();
      temp.sort(sortNewestFirst ? newestFirstComparator : oldestFirstComparator);
      list = temp;
    }
    list = list.skip(start);
    if (length > 0) {
      list = list.take(length);
    }
    return list;
  }

  /// writeToJsonMap write ModelIndex to json map
  Map<String, dynamic> writeToJsonMap() {
    sort();
    final map = <String, dynamic>{
      "0": _list.map((m) => m.writeToJsonMap()).toList(),
      "1": noMoreOnRemote,
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
    noMoreOnRemote = v1;
    sort();
  }

  /// clear all model
  Future<void> clear() async {
    for (final model in _list) {
      await onRemove?.call(model.i);
    }
    _list.clear();
  }
}
