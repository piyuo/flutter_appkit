import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/pb/src/common/common.dart' as common;

class DB {
  DB(this._box);

  final Box _box;

  /// keys is all the keys in the box, The keys are sorted alphabetically in ascending order.
  Iterable<dynamic> get keys => _box.keys;

  /// keyAt return the n-th key in the box.
  Future<dynamic> keyAt(int index) async => _box.keyAt(index);

  /// length is the number of entries in the box.
  int get length => _box.length;

  /// isEmpty returns `true` if there are no entries in this box.
  bool get isEmpty => _box.isEmpty;

  /// isNotEmpty returns true if there is at least one entries in this box.
  bool get isNotEmpty => _box.isNotEmpty;

  /// contains checks whether the box contains the [key].
  bool contains(dynamic key) => _box.containsKey(key);

  /// put saves the [key] - [value] pair
  Future<void> set(dynamic key, dynamic value) => _box.put(key, value);

  /// get returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  ///
  /// If [defaultValue] is specified, it is returned in case the key does not exist.
  Future<dynamic> get(dynamic key, {dynamic defaultValue}) async => _box.get(key, defaultValue: defaultValue);

  /// deletes the given [key] from the box , If it does not exist, nothing happens.
  Future<void> delete(dynamic key) => _box.delete(key);

  /// deleteFromDisk remove the file which contains the box and closes the box. In the browser, the IndexedDB database is being removed.
  Future<void> deleteFromDisk() => _box.deleteFromDisk();
}

/// init database env
Future<void> init(Map<String, pb.ObjectBuilder> builders) async {
  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  final map = <String, pb.ObjectBuilder>{'common': common.objectBuilder}..addAll(builders);
  Hive.registerAdapter(ObjectBuilderAdapter(builders: map));
}

/// init database env
@visibleForTesting
Future<void> initForTest(Map<String, pb.ObjectBuilder> builders) async {
  Hive.init('test.db');
  final map = <String, pb.ObjectBuilder>{'common': common.objectBuilder}..addAll(builders);
  Hive.registerAdapter(ObjectBuilderAdapter(builders: map));
}

/// use a db, create new one if database not exists
Future<DB> use(String dbName) async {
  final box = await Hive.openBox(dbName);
  return DB(box);
}

class ObjectBuilderAdapter extends TypeAdapter<pb.Object> {
  ObjectBuilderAdapter({
    required this.builders,
  });

  final Map<String, pb.ObjectBuilder> builders;

  @override
  final typeId = 0;

  @override
  pb.Object read(BinaryReader reader) {
    String namespace = reader.readString();
    assert(builders.containsKey(namespace),
        "$namespace not found, make sure you register {'$namespace':objectBuilder} in app.start()");
    final builder = builders[namespace]!;
    int id = reader.readInt();
    final bytes = reader.readByteList();
    return builder(id, bytes);
  }

  @override
  void write(BinaryWriter writer, pb.Object obj) {
    writer.writeString(obj.namespace());
    writer.writeInt(obj.mapIdXXX());
    var bytes = obj.writeToBuffer();
    writer.writeByteList(bytes);
  }
}
