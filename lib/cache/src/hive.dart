import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/pb/pb.dart' as pb;

/// _hivePath is hive database path, empty string for web
String? _hivePath;

/// initHive must call before use
/// ```dart
/// await initHive();
/// ```
Future<void> _initHive() async {
  if (_hivePath != null) return;
  if (testing.isTestMode) {
    _hivePath = 'test.hive';
    Hive.init(_hivePath!);
    debugPrint('[hive] init $_hivePath');
    return;
  }

  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    _hivePath = directory.path;
    debugPrint('[hive] init $_hivePath');
    Hive.init(_hivePath!);
  }
  _hivePath = '';
}

/// deleteBox delete box forever
/// ```dart
/// await deleteBox('box_name');
/// ```
Future<void> deleteBox(LazyBox box) async {
  await deleteBoxByName(box.name);
}

/// deleteBoxByName delete box forever
/// ```dart
/// await deleteBoxByName('box_name');
/// ```
@visibleForTesting
Future<void> deleteBoxByName(String name) async {
  if (await Hive.boxExists(name, path: _hivePath)) {
    await Hive.deleteBoxFromDisk(name, path: _hivePath);
  }
}

/// resetBox clear everything in box
/// ```dart
/// await resetBox(box);
/// ```
Future<void> resetBox(LazyBox box) async {
  for (var key in box.keys) {
    await box.delete(key);
  }
}

/// isBoxExists return true if box is exists
/// ```dart
/// bool found=await isBoxExists('box_name');
/// ```
Future<bool> isBoxExists(String name) async => await Hive.boxExists(name, path: _hivePath);

/// getBox return box to use, share same box if same name, create new one if box not exists
/// ```dart
/// final box = await getBox('box_name');
/// ```
Future<LazyBox> openBox(String name) async {
  await _initHive();
  return await Hive.openLazyBox(name);
}

/// closeBox close box
///
/// Do I have to call Hive.close()?
///
/// No, you don't. It might speed up the next start of your app but nothing to worry about.
///
/// ```dart
/// final box = await closeBox('box_name');
/// ```
Future<void> closeBox(LazyBox box) async {
  //Hive is an append-only data store. When you change or delete a value, the change is written to the end of the box file. Sooner or later, the box file uses more disk space than it should. Hive may automatically "compact" your box at any time to close the "holes" in the file.
  //It may benefit the start time of your app if you induce compaction manually before you close a box.
  await box.compact();
  await box.close();
}

/// putBoxObject save object to box
/// ```dart
/// await putBoxObject('k', person);
/// ```
Future<void> putBoxObject(LazyBox box, String key, pb.Object value) async => await box.put(key, value.writeToBuffer());

/// getBoxObject return the value associated with the given [key]
/// ```dart
/// final value = getBoxObject<sample.Person>('k', () => sample.Person());
/// ```
Future<T?> getBoxObject<T extends pb.Object>(LazyBox box, String key, pb.Builder<T> builder) async {
  final value = await box.get(key);
  if (value == null) {
    return null;
  }
  return builder()..mergeFromBuffer(value);
}
