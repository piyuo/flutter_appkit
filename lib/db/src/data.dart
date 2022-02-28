import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'db.dart';
import 'memory.dart';

/// DataGetter get data from remote service
/// ```dart
/// dataGetter: (context, id) async {
///   return sample.Person();
/// },
/// ```
typedef DataGetter<T> = Future<T?> Function(BuildContext context, String id);

/// DataSetter set data to remote service, return updated object if set success
/// ```dart
/// dataSetter: (context, sample.Person person) async {
///   person.name = 'john';
///   return person;
/// }
/// ```
typedef DataSetter<T> = Future<T> Function(BuildContext context, T obj);

/// Data provide a way to access data though data/memory/db
/// ```dart
/// final dp = Data<sample.Person>(
///   dataBuilder: () => sample.Person(),
///   dataGetter: (context, id) async => null,
///   dataSetter: (context, sample.Person person) async {
///     person.name = 'john';
///     return person;
///   },
/// );
/// ```
class Data<T extends pb.Object> with ChangeNotifier {
  /// Data provide a way to access data though data/memory/db
  /// ```dart
  /// final dp = Data<sample.Person>(
  ///   dataBuilder: () => sample.Person(),
  ///   dataGetter: (context, id) async => null,
  ///   dataSetter: (context, sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  Data({
    required pb.Builder<T> dataBuilder,
    required this.dataGetter,
    required this.dataSetter,
  });

  /// _memory keep all rows in memory
  Memory<T>? _memory;

  /// DataGetter get data from remote service
  final DataGetter<T> dataGetter;

  /// DataSetter set data to remote service
  final DataSetter<T> dataSetter;

  /// _data keep current data
  T? current;

  /// state is the state of this source
  DataState state = DataState.initial;

  /// notifyState change state and notify listener
  void notifyState(DataState newState) {
    state = newState;
    notifyListeners();
  }

  /// byData data with exists data object
  /// ```dart
  /// await dp.byData(sample.Person());
  /// ```
  Future<void> byData(T data) async {
    current = data;
    notifyState(DataState.ready);
  }

  /// byID open data though data getter
  /// ```dart
  /// await dp.byID(testing.Context(), 'id');
  /// ```
  Future<void> byID(BuildContext context, String id) async {
    final data = await dataGetter(context, id);
    if (data == null) {
      notifyState(DataState.dataMissing);
      return;
    }
    current = data;
    notifyState(DataState.ready);
  }

  /// byMemory open data though memory
  /// ```dart
  /// await dp.byMemory('hi', memory);
  /// ```
  Future<void> byMemory(String id, Memory<T> memory) async {
    _memory = memory;
    final data = await memory.getRowByID(id);
    if (data == null) {
      notifyState(DataState.dataMissing);
      return;
    }
    current = data;
    notifyState(DataState.ready);
  }

  /// save data to cache, only update cache when dataSetter return true
  /// ```dart
  /// await dp.save(testing.Context());
  /// ```
  Future<void> save(BuildContext context) async {
    if (current == null) {
      return;
    }
    notifyState(DataState.refreshing);
    try {
      final result = await dataSetter(context, current!);
      current = result;
      if (_memory != null) {
        await _memory!.setRow(current!);
      }
    } finally {
      notifyState(DataState.ready);
    }
  }
}
