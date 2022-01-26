import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'data.dart';
import 'data_common.dart';

class DataProvider<T extends pb.Object> extends DataCommon<T> with ChangeNotifier {
  DataProvider({
    BuildContext? context,
    String? id,
    required this.dataGetter,
    required this.dataSetter,
    required pb.Builder<T> dataBuilder,
    DataRemover<T>? dataRemover,
    this.onUpdateBegin,
    this.onUpdateEnd,
    this.dataLoaded,
    bool forceRefresh = false,
  }) : super(
          dataBuilder: dataBuilder,
          dataRemover: dataRemover,
        ) {
    if (context != null && id != null) {
      init(context, id, forceRefresh);
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

  /// dataLoaded is called when data load
  void Function(T? data)? dataLoaded;

  /// _data keep current data
  T? _data;

  /// current keep current data
  T? get current => _data;

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

  /// init data from cache, use data getter if not exist, forceRefresh will check entity is not going to change and refresh if not true
  Future<void> init(BuildContext context, String id, bool forceRefresh) async {
    _notifyLoading(true);
    try {
      _data = cache.getObject<T>(id, dataBuilder);
      if (forceRefresh && _data != null && !_data!.entityNotGoingToChange) {
        _data = null;
      }
      _data ??= await dataGetter(context, id);
      if (_data != null) {
        await cache.setObject(id, _data!);
      }
      onDataLoaded();
    } finally {
      _notifyLoading(false);
    }
  }

  /// onDataLoaded is called when data loaded
  void onDataLoaded() {
    dataLoaded?.call(_data);
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
      assert(item.getEntity() != null, 'set item must have entity');
      await dataSetter(context, item);
      await cache.setObject(item.entityID, item);
      _data = item;
    } finally {
      _updateEnd(context);
    }
  }

  /// delete data from data pod, it will set a empty deleted item
  Future<void> delete(BuildContext context, String id) async {
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
