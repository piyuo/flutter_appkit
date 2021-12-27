import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:libcli/pb/pb.dart' as pb;

typedef InstanceBuilder<T> = T Function(int id, List<int> bytes);

class DB {
  DB(this._box);

  final Box _box;

  /// keys is all the keys in the box, The keys are sorted alphabetically in ascending order.
  Iterable<dynamic> get keys => _box.keys;

  /// length is the number of entries in the box.
  int get length => _box.length;

  /// isEmpty returns `true` if there are no entries in this box.
  bool get isEmpty => _box.isEmpty;

  /// isNotEmpty returns true if there is at least one entries in this box.
  bool get isNotEmpty => _box.isNotEmpty;

  /// containsKey checks whether the box contains the [key].
  bool containsKey(dynamic key) => _box.containsKey(key);

  /// put saves the [key] - [value] pair
  Future<void> put(dynamic key, dynamic value) {
    return _box.put(key, value);
  }

  /// get returns the value associated with the given [key]. If the key does not exist, `null` is returned.
  ///
  /// If [defaultValue] is specified, it is returned in case the key does not exist.
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  /// deletes the given [key] from the box , If it does not exist, nothing happens.
  Future<void> delete(dynamic key) {
    return _box.delete(key);
  }

  /// deleteFromDisk remove the file which contains the box and closes the box. In the browser, the IndexedDB database is being removed.
  Future<void> deleteFromDisk() => _box.deleteFromDisk();
}

/// init database env
Future<void> init() async {
  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
}

/// init database env
@visibleForTesting
Future<void> initForTest() async {
  Hive.init('test.db');
}

/// registerBuilder registers a [builder] for generate pb.Object
void registerBuilder(InstanceBuilder builder) async {
  Hive.registerAdapter(ObjectAdapter(builder: builder));
}

/// use a db, create new one if database not exists
Future<DB> use(String dbName) async {
  final box = await Hive.openBox(dbName);
  return DB(box);
}

class ObjectAdapter extends TypeAdapter<pb.Object> {
  ObjectAdapter({
    required this.builder,
  });

  final InstanceBuilder builder;

  @override
  final typeId = 0;

  @override
  pb.Object read(BinaryReader reader) {
    int id = reader.readInt();
    final bytes = reader.readByteList();
    return builder(id, bytes);
  }

  @override
  void write(BinaryWriter writer, pb.Object obj) {
    writer.writeInt(obj.mapIdXXX());
    var bytes = obj.writeToBuffer();
    writer.writeByteList(bytes);
  }
}
