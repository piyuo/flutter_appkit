import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/general/general.dart' as types;
import 'dataset.dart';

/// DataClientLoader load data from remote service
/// ```dart
/// loader: ( id) async {
///   return sample.Person();
/// },
/// ```
typedef DataClientLoader<T> = Future<T?> Function(String id);

/// DataClientSaver save data to remote service
typedef DataClientSaver<T> = Future<void> Function(List<T> list);

/// DataClient provide a way to access data though dataset
class DataClient<T extends pb.Object> {
  /// DataClient provide a way to access data though dataset
  /// ```dart
  /// final dc = DataClient<sample.Person>(
  ///   creator: () => sample.Person(),
  ///   loader: (id) async => null,
  ///   saver: (sample.Person person) async {
  ///     person.name = 'john';
  ///     return person;
  ///   },
  /// );
  /// ```
  DataClient({
    required this.creator,
    required this.loader,
    required this.saver,
  });

  /// _dataset keep all rows in dataset
  late Dataset<T> dataset;

  /// creator create new row
  final types.FutureCallback<T> creator;

  /// loader get data from remote service
  final DataClientLoader<T> loader;

  /// saver save data to remote service
  final DataClientSaver<T> saver;

  /// load dataset if not set, get data if id present
  /// ```dart
  /// await client.load(testing.Context(), dataset:ds, id:'id-123');
  /// ```
  Future<T> load({required Dataset<T> dataset, String? id}) async {
    this.dataset = dataset;
    await dataset.load();

    if (id != null && id.length > 1) {
      var data = await dataset.read(id);
      if (data != null) {
        return data;
      }

      data = await loader(id);
      if (data != null) {
        dataset.insert([data]);
        return data;
      }
    }
    return creator();
  }

  /// setDataset only set dataset,it used when load data is not need
  /// ```dart
  /// await client.setDataset(ds);
  /// ```
  void setDataset(Dataset<T> dataset) => this.dataset = dataset;

  /// save data to dataset and remote service
  Future<void> save(List<T> list) async {
    await saver(list);
    await dataset.insert(list);
  }

  /// restore data from deleted/archived to active
  Future<void> restore(List<T> list) async {
    for (final item in list) {
      item.markAsActive();
    }
    await saver(list);
    await dataset.insert(list);
  }

  /// delete data from dataset and remote service
  Future<void> delete(List<T> list) async {
    for (final item in list) {
      item.markAsDeleted();
    }
    await saver(list);
    await dataset.delete(list.map((row) => row.id).toList());
  }

  /// archive data from dataset and remote service
  Future<void> archive(List<T> list) async {
    for (final item in list) {
      item.markAsArchived();
    }
    await saver(list);
    await dataset.delete(list.map((row) => row.id).toList());
  }
}
