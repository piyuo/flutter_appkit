import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'memory.dart';

/// DetailGetter get data from remote service
/// ```dart
/// getter: (context, id) async {
///   return sample.Person();
/// },
/// ```
typedef DetailGetter<T> = Future<T?> Function(BuildContext context, String id);

/// DetailSetter set data to remote service, return updated object if set success
/// ```dart
/// setter: (context, sample.Person person) async {
///   person.name = 'john';
///   return person;
/// }
/// ```
typedef DetailSetter<T> = Future<T> Function(BuildContext context, T obj);

/// Detail provide a way to access data though memory
/// ```dart
/// final dp = Detail<sample.Person>(
///   context: context,
///   dataBuilder: () => sample.Person(),
///   getter: (context, id) async => null,
///   setter: (context, sample.Person person) async {
///     person.name = 'john';
///     return person;
///   },
/// );
/// ```
class Detail<T extends pb.Object> with ChangeNotifier {
  /// Detail provide a way to access data though memory
  /// ```dart
  /// final dp = Detail<sample.Person>(
  ///   context: context,
  ///   dataBuilder: () => sample.Person(),
  ///   getter: (context, id) async => null,
  ///   setter: (context, sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  Detail(
    this._memory, {
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

  /// _memory keep all rows in memory
  final Memory<T> _memory;

  /// getter get data from remote service
  final DetailGetter<T> getter;

  /// setter set data to remote service
  final DetailSetter<T> setter;

  /// id is the id of data
  String? id;

  /// current keep current data
  T? current;

  /// _isLoading is true when detail is loading data
  bool _isLoading = false;

  /// isLoading is true when detail is loading data
  bool get isLoading => _isLoading;

  /// load data to memory
  /// ```dart
  /// await detail.load(testing.Context());
  /// ```
  Future<void> load(BuildContext context) async {
    if (current != null || id == null) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      current = await _memory.getRowByID(id!);
      if (current != null) {
        return;
      }

      current = await getter(context, id!);
      if (current != null) {
        _memory.setRow(current!);
        return;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// save data to cache, only update cache when dataSetter return true
  /// ```dart
  /// detail.current = sample.Person()..name = 'john';
  /// await detail.save(context);
  /// ```
  Future<void> save(BuildContext context) async {
    if (current == null) {
      return;
    }
    current = await setter(context, current!);
    await _memory.setRow(current!);
  }
}
