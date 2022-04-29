import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'database.dart';

/// DatasetState is data source state.
enum DataState {
  initial, // initial state
  refreshing, // refresh new data
  loading, // loading more data
  ready, // ready to show data
}

/// hivePath is hive database path
String? hivePath;

/// initDB database env
/// ```dart
/// await initDB();
/// ```
Future<void> initDB() async {
  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    hivePath = directory.path;
    debugPrint('hivePath: $hivePath');
    Hive.init(hivePath!);
  }
}

/// initDBForTest init database env in test mode
/// ```dart
/// await initDBForTest();
/// ```
@visibleForTesting
Future<void> initDBForTest() async {
  hivePath = 'test.hive';
  debugPrint('hivePath: $hivePath');
  Hive.init(hivePath!);
}

/// openDatabase open a database to use, create new one if database not exists
/// ```dart
/// final database = await openDatabase('database_name');
/// ```
Future<Database> openDatabase(String name) async {
  final box = await Hive.openBox(name);
  return Database(box);
}

/// deleteDatabase delete a database forever
/// ```dart
/// await deleteDatabase('database_name');
/// ```
Future<void> deleteDatabase(String name) async {
  if (await Hive.boxExists(name, path: hivePath)) {
    await Hive.deleteBoxFromDisk(name, path: hivePath);
  }
  debugPrint('[db] $name deleted');
}

/// isDatabaseExists return true if database is exists
/// ```dart
/// bool found=await isDatabaseExists('database_name');
/// ```
Future<bool> isDatabaseExists(String name) async => await Hive.boxExists(name, path: hivePath);
