import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;

/// ModelIndex is a tracker for model cache, it provide cutOffDate and view to help use local cache model
class ModelIndex {
  ModelIndex({
    this.onRemove,
  });

  /// _list keep all model
  final _list = <pb.Model>[];

  /// cutOffDate is the date that all model before this date will be removed
  DateTime? _cutOffDate;

  /// lastRefreshDate is the last refresh date
  DateTime? lastRefreshDate;

  /// onRemove is the callback when model is removed
  final Future<void> Function(String id)? onRemove;

  /// cutOffDate is the date that all model before this date will be removed
  DateTime? get cutOffDate => _cutOffDate;

  /// cutOffDate is the date that all model before this date will be removed
  set cutOffDate(DateTime? date) {
    _cutOffDate = date;
    if (_cutOffDate != null) {
      _list.removeWhere((obj) {
        final deleted = obj.t.toDateTime().isBefore(_cutOffDate!);
        if (deleted) {
          onRemove?.call(obj.i);
        }
        return deleted;
      });
    }
  }

  /// remove exists model
  void remove(String id) {
    _list.removeWhere((obj) => obj.i == id);
    onRemove?.call(id);
  }

  /// removeAll remove all model to list
  void removeAll(List<pb.Model> models) {
    for (final model in models) {
      remove(model.i);
    }
  }

  /// add model to list, return true if it can be add
  bool add(pb.Model model) {
    final exists = where(model.i);
    if (exists != null) {
      if (exists.t.toDateTime().isAfter(model.t.toDateTime())) {
        return false;
      }
      remove(model.i); // remove old model if exists. new model may have new t
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

  /// newest model
  pb.Model get newest {
    sort();
    return _list.last;
  }

  /// oldest model
  pb.Model get oldest {
    sort();
    return _list.first;
  }

  /// createView create a view of model list
  Iterable<pb.Model> createView({
    DateTime? from,
    DateTime? to,
    bool sortDesc = true,
    bool skipDeleted = true,
  }) {
    sort(desc: sortDesc);
    return _list.where((obj) {
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
  }

  /// writeToJsonMap write ModelIndex to json map
  Map<String, dynamic> writeToJsonMap() {
    final map = <String, dynamic>{
      "0": _cutOffDate == null ? 0 : _cutOffDate!.microsecondsSinceEpoch,
      "1": lastRefreshDate == null ? 0 : lastRefreshDate!.microsecondsSinceEpoch,
      "2": _list.map((m) => m.writeToJsonMap()).toList(),
    };
    return map;
  }

  /// fromString create ModelIndex from string
  void fromJsonMap(Map<String, dynamic> map) {
    final v0 = map["0"];
    _cutOffDate = v0 == 0 ? null : DateTime.fromMicrosecondsSinceEpoch(v0);
    final v1 = map["1"];
    lastRefreshDate = v1 == 0 ? null : DateTime.fromMicrosecondsSinceEpoch(v1);
    final v2 = map["2"];
    _list.clear();
    for (final item in v2) {
      _list.add(pb.Model()..mergeFromJsonMap(item));
    }
  }

  /// clearExpiredModel remove all model before cutOffDate
  void clearExpiredModel(DateTime expiredDate) {
    if (_cutOffDate != null && _cutOffDate!.isBefore(expiredDate)) {
      _cutOffDate = expiredDate;
    }
    _list.removeWhere((obj) {
      final deleted = obj.t.toDateTime().isBefore(expiredDate);
      if (deleted) {
        onRemove?.call(obj.i);
      }
      return deleted;
    });
  }

  /// getNeedUpdateRange return date range that need to update
  /*general.DateRange? getNeedUpdateRange(general.DateRange want) {
    final from = want.from;
    final to = want.to;
    final view = createView(from: from, to: to, sortDesc: true, skipDeleted: true);
    if (view.isEmpty) {
      return want;
    }
    final oldest = view.first;
    final newest = view.last;
    final fromNeedUpdate = from == null || oldest.t.toDateTime().isBefore(from);
    final toNeedUpdate = to == null || newest.t.toDateTime().isAfter(to);
    if (fromNeedUpdate && toNeedUpdate) {
      return want;
    }
    if (fromNeedUpdate) {
      return general.DateRange(from: oldest.t.toDateTime(), to: to);
    }
    if (toNeedUpdate) {
      return general.DateRange(from: from, to: newest.t.toDateTime());
    }
    return want;
  }*/
}
