import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// DataClientGetter get data from remote service
/// ```dart
/// getter: (context, id) async {
///   return sample.Person();
/// },
/// ```
typedef DataClientGetter<T> = Future<T?> Function(BuildContext context, String id);

/// DataClientSetter set data to remote service, return updated object if set success
/// ```dart
/// setter: (context, sample.Person person) async {
///   person.name = 'john';
///   return person;
/// }
/// ```
typedef DataClientSetter<T> = Future<T?> Function(BuildContext context, T obj);

/// DataClient provide a way to access data though dataset
/// ```dart
/// final dc = DataClient<sample.Person>(
///   dataBuilder: () => sample.Person(),
///   getter: (context, id) async => null,
///   setter: (context, sample.Person person) async {
///     person.name = 'john';
///     return person;
///   },
/// );
/// ```
class DataClient<T extends pb.Object> {
  /// DataClient provide a way to access data though dataset
  /// ```dart
  /// final dc = DataClient<sample.Person>(
  ///   dataBuilder: () => sample.Person(),
  ///   getter: (context, id) async => null,
  ///   setter: (context, sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  DataClient(
    this.dataset, {
    required pb.Builder<T> dataBuilder,
    required this.getter,
    required this.setter,
  });

  /// dataset keep all rows in dataset
  final Dataset<T> dataset;

  /// getter get data from remote service
  final DataClientGetter<T> getter;

  /// setter set data to remote service,return null if fail to set data
  final DataClientSetter<T> setter;

  /// data keep current data
  T? data;

  /// isReady is true when data is ready to use
  bool get isReady => data != null;

  /// load dataset, get data if id present
  /// ```dart
  /// await detail.load(testing.Context());
  /// ```
  Future<void> load(BuildContext context, {required String id}) async {
    await dataset.load();
    if (id.isEmpty) {
      return;
    }
    data = await dataset.read(id);
    if (data != null) {
      return;
    }

    data = await getter(context, id);
    if (data != null) {
      dataset.update(context, data!);
      return;
    }
  }

  /// save data to cache, only update cache when setter return true
  /// ```dart
  /// detail.current = sample.Person()..name = 'john';
  /// await detail.save(context);
  /// ```
  Future<bool> save(BuildContext context) async {
    if (data == null) {
      return false;
    }
    data = await setter(context, data!);
    if (data != null) {
      await dataset.update(context, data!);
      return true;
    }
    return false;
  }
}
