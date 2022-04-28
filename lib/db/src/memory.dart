import 'package:libcli/pb/pb.dart' as pb;

/// keyAll is key for keep all rows
const keyIndex = '__idx';

/// keyRowsPerPage is key for keep all rows per page
const keyRowsPerPage = '__rpp';

/// keyNoMoreData is key for no more data
const keyNoMore = '__nm';

/// keyNoRefresh is key for no refresh
const keyNoRefresh = '__nr';

/// Memory keep rows for later use
/// ```dart
/// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
/// await memory.open();
/// ```
abstract class Memory<T extends pb.Object> {
  /// Memory keep rows for later use
  /// ```dart
  /// final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
  /// await memory.open();
  /// ```
  Memory({
    required this.dataBuilder,
  });

  /// dataBuilder build data
  /// ```dart
  /// dataBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> dataBuilder;

  /// internalNoRefresh mean dataset has no need to refresh data, it will only use data in memory
  bool internalNoRefresh = false;

  /// noRefresh mean dataset has no need to refresh data, it will only use data in memory
  bool get noRefresh => internalNoRefresh;

  /// setNoRefresh set true mean dataset has no need to refresh data, it will only use data in memory
  Future<void> setNoRefresh(value) async => internalNoRefresh = value;

  /// internalNoMore mean dataset has no need to load more data, it will only use data in memory
  bool internalNoMore = false;

  /// noMore mean dataset has no need to load more data, it will only use data in memory
  bool get noMore => internalNoMore;

  /// setNoMore set true mean dataset has no need to load more data, it will only use data in memory
  Future<void> setNoMore(value) async => internalNoMore = value;

  /// internalRowsPerPage is current rows per page
  int internalRowsPerPage = 10;

  /// rowsPerPage is current rows per page
  int get rowsPerPage => internalRowsPerPage;

  /// setRowsPerPage set current rows per page
  Future<void> setRowsPerPage(value) async => internalRowsPerPage = value;

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  int get length;

  /// open memory and load content
  Future<void> open() async {}

  /// reload memory content
  Future<void> reload() async {}

  /// close memory
  Future<void> close() async {}

  /// insert list of rows into memory, it will avoid duplicate rows
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  Future<void> insert(List<T> list);

  /// add list of rows into memory, it will avoid duplicate rows
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  Future<void> add(List<T> list);

  /// delete list of rows from memory
  /// ```dart
  /// await memory.delete(list);
  /// ```
  Future<void> delete(List<T> list);

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  Future<void> clear();

  /// setRow set a single row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  Future<void> setRow(T row);

  /// getRow return row by id
  /// ```dart
  /// final obj = await memory.getRow('1');
  /// ```
  Future<T?> getRow(String id);

  /// subRows return sublist of rows
  /// ```dart
  /// var subRows = await memory.range(0, 10);
  /// ```
  Future<List<T>?> range(int start, [int? end]);

  /// allRows return all rows, return null if something went wrong
  /// ```dart
  /// var rowsAll = await memory.all;
  /// ```
  Future<List<T>?> get all async => await range(0, length);

  /// forEach iterate all rows
  /// ```dart
  /// await memory.forEach();
  /// ```
  Future<void> forEach(void Function(T) callback);

  /// isIDExists return true if id is in memory
  /// ```dart
  /// await memory.isIDExists();
  /// ```
  bool isIDExists(String id);

  /// first return first row
  /// ```dart
  /// await memory.first;
  /// ```
  Future<T?> get first;

  /// last return last row
  /// ```dart
  /// await memory.last;
  /// ```
  Future<T?> get last;

  /// isEmpty return rows is empty
  /// ```dart
  /// await memory.isEmpty;
  /// ```
  bool get isEmpty => length == 0;

  /// isNotEmpty return rows is not empty
  /// ```dart
  /// await memory.isNotEmpty;
  /// ```
  bool get isNotEmpty => !isEmpty;
}
