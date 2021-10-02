import 'dart:core';
import 'package:libcli/pb.dart' as pb;
import 'registries.dart';

/// add to the cache, this is a FIFO cache, return true if success save to cache, it will not save if object's base64 string exceed maxCachedSize
///
///     final obj = pb.Error()..code = 'hi';
///     var result = await add('key1', obj);
///
Future<bool> add(
  String key,
  pb.Object obj, {
  Duration expire = const Duration(days: 31),
}) async {
  final list = [obj.toBase64()];
  return (await saveToCache(key, list, expire)) != null;
}

/// get object from cache. obj can be a empty object
///
///     final obj2 = await get<pb.Error>('key1', pb.Error());
///
Future<T?> get<T extends pb.Object>(String key, T obj) async {
  final list = await loadFromCache(key);
  if (list == null || list.isEmpty) {
    return null;
  }
  obj.fromBase64(list[0]);
  return obj;
}

/// addList to the cache, this is a FIFO cache, return true if success save to cache, it will not save if object's base64 string exceed maxCachedSize
///
///      final obj1 = pb.Error()..code = '1';
///      final obj2 = pb.Error()..code = '2';
///      final list = [obj1, obj2];
///      var result = await addList('key1', list);
///
Future<bool> addList(
  String key,
  List<pb.Object> objList, {
  Duration expire = const Duration(days: 31),
}) async {
  final list = <String>[];
  for (final obj in objList) {
    list.add(obj.toBase64());
  }
  return (await saveToCache(key, list, expire)) != null;
}

/// get object list from cache.
///
///     final list2 = await getList<pb.Error>('key1', () => pb.Error());
///
Future<List<T>?> getList<T extends pb.Object>(String key, pb.ObjectBuilder builder) async {
  final strList = await loadFromCache(key);
  if (strList == null || strList.isEmpty) {
    return null;
  }
  final list = <T>[];
  for (final str in strList) {
    final obj = builder();
    obj.fromBase64(str);
    list.add(obj);
  }
  return list;
}
