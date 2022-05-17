import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';

/// DatabaseBuilder build database
typedef DatabaseBuilder = Future<Database> Function(String name);

/// _name is current database name
String _name = '';

// _database is current database
Database? _database;

/// _count is current database usage count
int _count = 0;

/// databaseUsageCount return current usage count
@visibleForTesting
int get databaseUsageCount => _count;

/// _inc increment current database usage count
void _inc() => _count++;

/// _dec decrement current database usage count, return true if count is zero
bool _dec() {
  _count--;
  if (_count <= 0) {
    _count = 0;
    return true;
  }
  return false;
}

/// resetDatabaseUsage reset all database usage, only use in testing
@visibleForTesting
void resetDatabaseUsage() {
  _name = '';
  _database = null;
  _count = 0;
}

/// DatabaseProvider create and keep track database usage, close it when no one use
class DatabaseProvider with ChangeNotifier {
  DatabaseProvider({
    required this.name,
    required this.databaseBuilder,
  });

  /// name is database name
  final String name;

  /// databaseBuilder is database builder
  final DatabaseBuilder databaseBuilder;

  /// database is current database
  Database get database => _database!;

  /// isReady return true if database is ready
  bool get isReady => _database != null;

  /// dispose database and reset counter
  @override
  void dispose() {
    if (name == _name && _database != null && _dec()) {
      _database!.close();
      _database = null;
    }
    super.dispose();
  }

  /// load a database
  Future<Database> load() async {
    if (name != _name) {
      resetDatabaseUsage();
    }
    _name = name;
    _database ??= await databaseBuilder(name);
    _inc();
    return _database!;
  }

  /// of get DatabaseProvider from context
  static DatabaseProvider of(BuildContext context) {
    return Provider.of<DatabaseProvider>(context, listen: false);
  }
}
