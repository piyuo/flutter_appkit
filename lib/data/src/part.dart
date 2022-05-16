import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// PartGetter get data from remote service
/// ```dart
/// getter: (context, id) async {
///   return sample.Person();
/// },
/// ```
typedef PartGetter<T> = Future<T?> Function(BuildContext context, String id);

/// PartSetter set data to remote service, return updated object if set success
/// ```dart
/// setter: (context, sample.Person person) async {
///   person.name = 'john';
///   return person;
/// }
/// ```
typedef PartSetter<T> = Future<T?> Function(BuildContext context, T obj);

/// Part provide a way to access data though dataset
/// ```dart
/// final dp = Part<sample.Person>(
///   context: context,
///   dataBuilder: () => sample.Person(),
///   getter: (context, id) async => null,
///   setter: (context, sample.Person person) async {
///     person.name = 'john';
///     return person;
///   },
/// );
/// ```
class Part<T extends pb.Object> with ChangeNotifier {
  /// Detail provide a way to access data though dataset
  /// ```dart
  /// final dp = Part<sample.Person>(
  ///   context: context,
  ///   dataBuilder: () => sample.Person(),
  ///   getter: (context, id) async => null,
  ///   setter: (context, sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  Part(
    this._dataset, {
    required pb.Builder<T> dataBuilder,
    required this.getter,
    required this.setter,
    this.id,
    BuildContext? context,
  }) {
    if (context != null) {
      load(context);
    }
  }

  /// _dataset keep all rows in dataset
  final Dataset<T> _dataset;

  /// getter get data from remote service
  final PartGetter<T> getter;

  /// setter set data to remote service,return null if fail to set data
  final PartSetter<T> setter;

  /// id is the id of data
  String? id;

  /// current keep current data
  T? current;

  /// _isLoading is true when detail is loading data
  bool _isLoading = false;

  /// isLoading is true when detail is loading data
  bool get isLoading => _isLoading;

  /// load data to dataset
  /// ```dart
  /// await detail.load(testing.Context());
  /// ```
  Future<void> load(BuildContext context) async {
    await _dataset.open();

    if (current != null || id == null) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      current = await _dataset.read(id!);
      if (current != null) {
        return;
      }

      current = await getter(context, id!);
      if (current != null) {
        _dataset.update(context, current!);
        return;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// save data to cache, only update cache when setter return true
  /// ```dart
  /// detail.current = sample.Person()..name = 'john';
  /// await detail.save(context);
  /// ```
  Future<bool> save(BuildContext context) async {
    if (current == null) {
      return false;
    }
    current = await setter(context, current!);
    if (current != null) {
      await _dataset.update(context, current!);
      return true;
    }
    return false;
  }
}
