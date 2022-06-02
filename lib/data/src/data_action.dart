import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'dataset.dart';

/// DataActionSaver save data to remote service
typedef DataActionSaver<T> = Future<void> Function(BuildContext context, List<T> list);

/// DataAction provide a way to update dataset and save data to remote
class DataAction<T extends pb.Object> {
  /// DataAction provide a way to update dataset and save data to remote
  DataAction({
    required this.dataset,
    required this.saver,
  });

  /// _dataset keep all rows in dataset
  Dataset<T> dataset;

  /// saver save data to remote service
  final DataActionSaver<T> saver;

  /// delete data from dataset and remote service
  Future<void> delete(BuildContext context, List<T> list) async {
/*
    for (final item in list) {
      item.entityDeleted = true;
    }

    await saver(context, list);
    await dataset.insert(context, [data]);
    if (data != null) {
      return data;
    }

    await dataset.delete(context, list);

    if (id.isNotEmpty) {
      var data = await dataset.read(id);
      if (data != null) {
        return data;
      }
    }
    return dataBuilder();
    */
  }

  /// setDataset only set dataset,it used when load data is not need
  /// ```dart
  /// await action.setDataset(ds);
  /// ```
  void setDataset(Dataset<T> dataset) => this.dataset = dataset;
}
