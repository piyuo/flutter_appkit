import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'database.dart';

const testDatabaseFile = 'test.db';

/// init database env
Future<void> init() async {
  if (!kIsWeb) {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
}

/// init database env
@visibleForTesting
Future<void> initForTest(String databaseName) async {
  Hive.init(testDatabaseFile);
  await deleteDatabase(databaseName, testDatabaseFile);
}

/// deleteDatabase delete database
Future<void> deleteDatabase(String databaseName, String file) async {
  if (await Hive.boxExists(databaseName, path: file)) {
    await Hive.deleteBoxFromDisk(databaseName, path: file);
  }
}

/// open a database to use, create new one if database not exists
Future<Database> open(String name) async {
  final database = Database();
  await database.open(name);
  return database;
}
