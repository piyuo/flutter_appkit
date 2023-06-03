//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:hive/hive.dart';
import 'hive.dart';

/// IndexedDbProvider use hive to store data in local or indexed db in browser
class IndexedDbProvider with ChangeNotifier, utils.NeedInitializeMixin {
  IndexedDbProvider({
    required String dbName,
  }) {
    initFuture = () async {
      debugPrint('[indexed_db] open $dbName');
      _box = await openBox(dbName);
    };
  }

  /// _box is hive box
  late LazyBox _box;

  /// dispose database and reset counter
  @override
  void dispose() {
    debugPrint('[indexed_db] close ${_box.name}');
    closeBox(_box);
    super.dispose();
  }

  /// of get instance from context
  static IndexedDbProvider of(BuildContext context) {
    return Provider.of<IndexedDbProvider>(context, listen: false);
  }

  /// keys is all the keys in the box, The keys are sorted alphabetically in ascending order.
  Iterable<String> get keys => _box.keys as Iterable<String>;

  /// keyAt return the n-th key in the box.
  Future<String> keyAt(int index) async => _box.keyAt(index);

  /// length is the number of entries in the box.
  int get length => _box.length;

  /// isEmpty returns `true` if there are no entries in this box.
  bool get isEmpty => _box.isEmpty;

  /// isNotEmpty returns true if there is at least one entries in this box.
  bool get isNotEmpty => _box.isNotEmpty;

  /// containsKey checks whether the box contains the [key].
  /// ```dart
  /// expect(indexedDbProvider.contains('a'), false);
  /// ```
  bool containsKey(String key) => _box.containsKey(key);

  /// put value to database
  /// ```dart
  /// await indexedDbProvider.put('key', {'a': 1}));
  /// ```
  Future<void> put(String key, dynamic value) async => await _box.put(key, value);

  /// get return the value associated with the given [key]
  /// ```dart
  /// final value = indexedDbProvider.get<int>('k');
  /// ```
  Future<T?> get<T>(String key) async => await _box.get(key);

  /// deppConvertMap convert map to json map
  Map<String, dynamic> deppConvertMap(Map<dynamic, dynamic> inputMap) {
    List<dynamic> convertList(List<dynamic> inputList) {
      List<dynamic> newList = [];

      for (dynamic item in inputList) {
        if (item is Map<dynamic, dynamic>) {
          newList.add(deppConvertMap(item));
        } else if (item is List<dynamic>) {
          newList.add(convertList(item));
        } else {
          newList.add(item);
        }
      }

      return newList;
    }

    dynamic convertValue(dynamic value) {
      if (value is Map<dynamic, dynamic>) {
        return deppConvertMap(value);
      } else if (value is List<dynamic>) {
        return convertList(value);
      } else {
        return value;
      }
    }

    Map<String, dynamic> newMap = {};

    inputMap.forEach((key, value) {
      if (key is String) {
        newMap[key] = convertValue(value);
      } else {
        String stringKey = key.toString();
        newMap[stringKey] = convertValue(value);
      }
    });

    return newMap;
  }

  /// getJsonMap return the json map object associated with the given [key]
  /// ```dart
  /// final value = indexedDbProvider.getJsonMap('k');
  /// ```
  Future<Map<String, dynamic>?> getJsonMap<T>(String key) async {
    final value = await _box.get(key);
    if (value == null) {
      return null;
    }

    //return jsonDecode(jsonEncode(value));
    return deppConvertMap(value);
  }

  /// putObject save object to database
  /// ```dart
  /// await indexedDbProvider.putObject('k', person);
  /// ```
  Future<void> putObject(String key, pb.Object value) async => await putBoxObject(_box, key, value);

  /// getObject return the value associated with the given [key]
  /// ```dart
  /// final value = indexedDbProvider.getObject<sample.Person>('k', () => sample.Person());
  /// ```
  Future<T?> getObject<T extends pb.Object>(String key, pb.Builder<T> builder) async =>
      await getBoxObject(_box, key, builder);

  /// delete the given [key] from the box ,if it does not exist, nothing happens.
  /// ```dart
  /// await indexedDbProvider.delete('k');
  /// ```
  Future<void> delete(String key) async {
    debugPrint('[indexed_db] delete $key');
    await _box.delete(key);
  }

  /// clear everything in box
  /// ```dart
  /// await clear();
  /// ```
  Future<void> clear() async => await resetBox(_box);

  /// removeBox remove db box file
  /// ```dart
  /// await removeBox();
  /// ```
  @visibleForTesting
  Future<void> removeBox() async => await deleteBox(_box);
}

/*
  /// getStringList return the value associated with the given [key]
  /// ```dart
  /// var list2 = indexedDbProvider.getStringList('l');
  /// ```
  Future<List<String>?> getStringList(String key) async {
    final list = await _box.get(key);
    if (list is List<dynamic>) {
      return list.map((item) => item.toString()).toList();
    }
    return null;
  }
 */