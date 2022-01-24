import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'data.dart';
import 'data_common.dart';

class DataPod<T extends pb.Object> extends DataCommon<T> with ChangeNotifier {
  DataPod({
    BuildContext? context,
    required this.dataGetter,
    required this.dataSetter,
    required pb.Builder<T> dataBuilder,
    required String id,
    DataRemover<T>? dataRemover,
    this.onUpdateBegin,
    this.onUpdateEnd,
    this.onLoad,
  }) : super(
          dataBuilder: dataBuilder,
          dataRemover: dataRemover,
          id: id,
        ) {
    if (context != null) {
      init(context);
    }
  }

  /// DataGetter get data from remote service
  final DataGetter<T> dataGetter;

  /// DataSetter set data to remote service
  final DataSetter<T> dataSetter;

  /// onRefreshBegin is called when data update begin
  VoidCallback? onUpdateBegin;

  /// onUpdateEnd is called when data update end
  VoidCallback? onUpdateEnd;

  /// onLoad is called when data load
  void Function(T? data)? onLoad;

  /// _data keep current data
  T? _data;

  /// data keep current data
  T? get data => _data;

  /// _isLoading return true if data source is busy loading data
  bool _isLoading = false;

  /// isLoading return true if data source is busy loading data
  bool get isLoading => _isLoading;

  /// isEmpty return true if data is empty
  bool get isEmpty => _data == null;

  /// isNotEmpty return true if data is not empty
  bool get isNotEmpty => _data != null;

  void _updateBegin(BuildContext context) {
    onUpdateBegin?.call();
  }

  void _updateEnd(BuildContext context) {
    onUpdateEnd?.call();
  }

  /// init data from cache, use data getter if not exist
  Future<void> init(BuildContext context) async {
    _notifyLoading(true);
    try {
      _data = cache.getObject<T>(id, dataBuilder);
      _data ??= await dataGetter(context, id);
      if (_data != null) {
        await cache.setObject(id, _data!);
      }
      onLoad?.call(_data);
    } finally {
      _notifyLoading(false);
    }
  }

  /// _notifyLoading set busy value and notify listener
  void _notifyLoading(bool value) {
    if (value != _isLoading) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// set data to cache
  Future<void> set(BuildContext context, T item) async {
    _updateBegin(context);
    try {
      assert(item.entityID == id, 'item.entityID must be $id');
      assert(item.getEntity() != null, 'set item must have entity');
      await dataSetter(context, item);
      await cache.setObject(id, item);
      _data = item;
    } finally {
      _updateEnd(context);
    }
  }

  /// delete data from data pod, it will set a empty deleted item
  Future<void> delete(BuildContext context) async {
    _updateBegin(context);
    try {
      assert(dataRemover != null, 'dataRemover must not be null');
      await dataRemover!(context, [id]);
      await setCacheDeleted([id], builder: dataBuilder);
      _data = null;
    } finally {
      _updateEnd(context);
    }
  }
}
