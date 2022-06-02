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
  DataClient({
    required this.dataBuilder,
    required this.getter,
  });

  /// dataBuilder build new row
  final pb.Builder<T> dataBuilder;

  /// _dataset keep all rows in dataset
  late Dataset<T> dataset;

  /// getter get data from remote service
  final DataClientGetter<T> getter;

  /// load dataset if not set, get data if id present
  /// ```dart
  /// await client.load(testing.Context(), ds, 'id-123');
  /// ```
  Future<T> load(BuildContext context, {required Dataset<T> dataset, required String id}) async {
    this.dataset = dataset;
    await dataset.load(context);

    if (id.isNotEmpty) {
      var data = await dataset.read(id);
      if (data != null) {
        return data;
      }

      data = await getter(context, id);
      if (data != null) {
        dataset.insert(context, [data]);
        return data;
      }
    }
    return dataBuilder();
  }

  /// setDataset only set dataset,it used when load data is not need
  /// ```dart
  /// await client.setDataset(ds);
  /// ```
  void setDataset(Dataset<T> dataset) => this.dataset = dataset;
}
