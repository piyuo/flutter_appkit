import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'data.dart';

class DataCommon<T extends pb.Object> {
  DataCommon({
    required this.dataBuilder,
    required this.id,
    this.dataRemover,
  });

  /// DataBuilder build data
  final pb.Builder<T> dataBuilder;

  /// DataRemover remove data, return true if removal success
  final DataRemover<T>? dataRemover;

  /// id is the unique id of this dataset, it is used to cache data
  final String id;

  /// set data to cache
  Future<void> setCacheDeleted(
    List<String> ids, {
    required pb.Builder builder,
  }) async {
    for (final id in ids) {
      final item = builder();
      item.setEntity(
        pb.Entity(
          id: id,
          updateTime: DateTime.now().utcTimestamp,
          deleted: true,
        ),
      );
      await cache.setObject(id, item);
    }
  }
}
