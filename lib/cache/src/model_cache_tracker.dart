import 'dart:core';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// ModelCacheTracker is a tracker for model cache, it provide cutOffDate and view to help use local cache model
class ModelCacheTracker {
  ModelCacheTracker({
    this.onRemove,
  });

  /// _list keep all model
  final _list = <pb.Model>[];

  /// cutOffDate is the date that all model before this date will be removed
  DateTime _cutOffDate = i18n.minDateTime;

  /// onRemove is the callback when model is removed
  final void Function(String id)? onRemove;

  /// cutOffDate is the date that all model before this date will be removed
  set cutOffDate(DateTime date) {
    _cutOffDate = date;
    _list.removeWhere((obj) {
      final deleted = obj.t.toDateTime().isBefore(_cutOffDate);
      if (deleted) {
        onRemove?.call(obj.i);
      }
      return deleted;
    });
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
}
