import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// DataClientLoader load data from remote service
/// ```dart
/// loader: (context, id) async {
///   return sample.Person();
/// },
/// ```
typedef DataClientLoader<T> = Future<T?> Function(BuildContext context, String id);

/// DataClientSaver save data to remote service
typedef DataClientSaver<T> = Future<void> Function(BuildContext context, List<T> list);

/// DataClient provide a way to access data though dataset
/// ```dart
/// final dc = DataClient<sample.Person>(
///   objectBuilder: () => sample.Person(),
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
  ///   objectBuilder: () => sample.Person(),
  ///   getter: (context, id) async => null,
  ///   setter: (context, sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  DataClient({
    required this.objectBuilder,
    required this.loader,
    required this.saver,
  });

  /// objectBuilder build new row
  final pb.Builder<T> objectBuilder;

  /// _dataset keep all rows in dataset
  late Dataset<T> dataset;

  /// loader get data from remote service
  final DataClientLoader<T> loader;

  /// saver save data to remote service
  final DataClientSaver<T> saver;

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

      data = await loader(context, id);
      if (data != null) {
        dataset.insert(context, [data]);
        return data;
      }
    }
    return objectBuilder();
  }

  /// setDataset only set dataset,it used when load data is not need
  /// ```dart
  /// await client.setDataset(ds);
  /// ```
  void setDataset(Dataset<T> dataset) => this.dataset = dataset;

  /// save data to dataset and remote service
  Future<void> save(BuildContext context, List<T> list) async {
    await saver(context, list);
    await dataset.insert(context, list);
  }

  /// restore data from deleted/archived to active
  Future<void> restore(BuildContext context, List<T> list) async {
    for (final item in list) {
      item.markAsActive();
    }
    await saver(context, list);
    await dataset.insert(context, list);
  }

  /// delete data from dataset and remote service
  Future<void> delete(BuildContext context, List<T> list) async {
    for (final item in list) {
      item.markAsDeleted();
    }
    await saver(context, list);
    await dataset.delete(context, list);
  }

  /// archive data from dataset and remote service
  Future<void> archive(BuildContext context, List<T> list) async {
    for (final item in list) {
      item.markAsArchived();
    }
    await saver(context, list);
    await dataset.delete(context, list);
  }
}
