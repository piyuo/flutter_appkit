import 'database.dart';
import 'base.dart';

/// open a database to use, create new one if database not exists
/// ```dart
/// final database = await open('database_name');
/// ```
Future<Database> open(String name) async {
  final box = await openBox(name);
  return Database(box);
}

/// delete a database forever
/// ```dart
/// await delete('database_name');
/// ```
Future<void> delete(String name) async => await deleteBox(name);

/// isExists return true if database is exists
/// ```dart
/// bool found=await isExists('database_name');
/// ```
Future<bool> isExists(String name) async => await isBoxExists(name);
