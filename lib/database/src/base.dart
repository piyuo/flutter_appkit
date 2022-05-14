import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

/// _hivePath is hive database path
String? _hivePath;

/// _boxes keep track all using box
Map<String, LazyBox> _boxes = {};

/// init hive, must call before use
/// ```dart
/// await init();
/// ```
Future<void> init() async {
  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    _hivePath = directory.path;
    debugPrint('hive path: $_hivePath');
    Hive.init(_hivePath!);
  }
}

/// initForTest init hive in test mode
/// ```dart
/// await initForTest();
/// ```
@visibleForTesting
Future<void> initForTest() async {
  _hivePath = 'test.hive';
  debugPrint('debug hive path: $_hivePath');
  Hive.init(_hivePath!);
}

/// reset delete all opened box
/// ```dart
/// final box = await reset();
/// ```
Future<void> reset() async {
  for (var name in _boxes.keys) {
    if (await Hive.boxExists(name, path: _hivePath)) {
      await Hive.deleteBoxFromDisk(name, path: _hivePath);
    }
  }
  _boxes.clear();
}

/// getBox return box to use, share same box if same name, create new one if box not exists
/// ```dart
/// final box = await getBox('box_name');
/// ```
Future<LazyBox> openBox(String name) async {
  var box = _boxes[name];
  if (box == null) {
    box = await Hive.openLazyBox(name);
    _boxes[name] = box;
  }
  debugPrint('[database] open box: $name, total opened: ${_boxes.length}');
  return box;
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
  _boxes.remove(box.name);
  //Hive is an append-only data store. When you change or delete a value, the change is written to the end of the box file. Sooner or later, the box file uses more disk space than it should. Hive may automatically "compact" your box at any time to close the "holes" in the file.
  //It may benefit the start time of your app if you induce compaction manually before you close a box.
  await box.compact();
  await box.close();
  debugPrint('[database] open box: ${box.name}, total opened: ${_boxes.length}');
}

/// deleteBox delete box forever
/// ```dart
/// await deleteBox('box_name');
/// ```
Future<void> deleteBox(String name) async {
  _boxes.remove(name);
  if (await Hive.boxExists(name, path: _hivePath)) {
    await Hive.deleteBoxFromDisk(name, path: _hivePath);
  }
  debugPrint('[db] $name deleted');
}

/// isBoxExists return true if box is exists
/// ```dart
/// bool found=await isBoxExists('box_name');
/// ```
Future<bool> isBoxExists(String name) async => await Hive.boxExists(name, path: _hivePath);
