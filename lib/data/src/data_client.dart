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

/// DataClientRemover set data to remote service, return updated object if set success
/// ```dart
/// remover: (context, sample.Person person) async {
///   delete person ...
/// }
/// ```
typedef DataClientRemover<T> = Future<bool> Function(BuildContext context, T obj);

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
    required this.dataBuilder,
    required this.getter,
    this.setter,
    this.remover,
  });

  /// dataBuilder build new row
  final pb.Builder<T> dataBuilder;

  /// dataset keep all rows in dataset
  final Dataset<T> dataset;

  /// getter get data from remote service
  final DataClientGetter<T> getter;

  /// setter set data to remote service,return null if fail to set data
  final DataClientSetter<T>? setter;

  /// remover remove data from remote service,return null if fail to remove data
  final DataClientRemover<T>? remover;

  /// load dataset, get data if id present
  /// ```dart
  /// await client.load(testing.Context(),'id-123');
  /// ```
  Future<T> load(BuildContext context, {required String id}) async {
    await dataset.load();
    if (id.isNotEmpty) {
      var data = await dataset.read(id);
      if (data != null) {
        return data;
      }

      data = await getter(context, id);
      if (data != null) {
        dataset.update(context, data);
        return data;
      }
    }
    return dataBuilder();
  }

  /// save data to cache, only update cache when setter return true
  /// ```dart
  /// final person = sample.Person()..name = 'john';
  /// await client.save(context, person);
  /// ```
  Future<bool> save(BuildContext context, T row) async {
    if (setter == null) {
      return false;
    }
    final updated = await setter!(context, row);
    if (updated != null) {
      await dataset.update(context, updated);
      return true;
    }
    return false;
  }

  /// delete data from cache, only delete cache when remover return true
  /// ```dart
  /// await client.delete(context, person);
  /// ```
  Future<bool> delete(BuildContext context, T row) async {
    if (remover == null) {
      return false;
    }
    final deleted = await remover!(context, row);
    if (deleted) {
      await dataset.delete(context, [row]);
    }
    return deleted;
  }
}
