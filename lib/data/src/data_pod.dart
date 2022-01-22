import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'data.dart';
import 'data_common.dart';

class DataPod<T extends pb.Object> extends DataCommon<T> {
  DataPod({
    required this.dataGetter,
    required this.dataSetter,
    required pb.Builder<T> dataBuilder,
    required String id,
    DataRemover<T>? dataRemover,
  }) : super(
          dataBuilder: dataBuilder,
          dataRemover: dataRemover,
          id: id,
        );

  /// DataGetter get data from remote service
  final DataGetter<T> dataGetter;

  /// DataSetter set data to remote service
  final DataSetter<T> dataSetter;

  /// get data from cache, use data getter if not exist
  Future<T?> get(BuildContext context) async {
    T? obj = cache.getObject<T>(id, dataBuilder);
    obj ??= await dataGetter(context, id);
    if (obj != null) {
      await cache.setObject(id, obj);
    }
    return obj;
  }

  /// set data to cache
  Future<void> set(BuildContext context, T item) async {
    assert(item.entityID == id, 'item.entityID must be $id');
    assert(item.getEntity() != null, 'set item must have entity');
    await dataSetter(context, item);
    await cache.setObject(id, item);
  }

  /// delete data from data pod, it will set a empty deleted item
  Future<void> delete(BuildContext context) async {
    assert(dataRemover != null, 'dataRemover must not be null');
    await dataRemover!(context, [id]);
    await setCacheDeleted([id], builder: dataBuilder);
  }
}
