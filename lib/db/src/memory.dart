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
    this.noRefresh = false,
    this.noMore = false,
    this.rowsPerPage = 10,
  });

  /// dataBuilder build data
  /// ```dart
  /// dataBuilder: () => sample.Person()
  /// ```
  final pb.Builder<T> dataBuilder;

  /// noRefresh mean dataset has no need to refresh data, it will only use data in memory
  bool noRefresh;

  /// noMore mean dataset has no need to load more data, it will only use data in memory
  bool noMore;

  /// rowsPerPage is current rows per page
  int rowsPerPage;

  /// length return rows length
  /// ```dart
  /// var len = memory.length;
  /// ```
  int get length;

  /// insert list of rows into memory, it will avoid duplicate rows
  /// ```dart
  /// await memory.insert([sample.Person()]);
  /// ```
  Future<void> insert(List<T> list);

  /// add list of rows into memory, it will avoid duplicate rows
  /// add rows into ram
  /// ```dart
  /// await memory.add([sample.Person(name: 'hi')]);
  /// ```
  Future<void> add(List<T> list);

  /// clear memory
  /// ```dart
  /// await memory.clear();
  /// ```
  Future<void> clear();

  /// save memory
  Future<void> save() async {}

  /// open memory
  Future<void> open() async {}

  /// close memory
  Future<void> close() async {}

  /// subRows return sublist of rows
  /// ```dart
  /// var subRows = await memory.subRows(0, 10);
  /// ```
  Future<List<T>?> subRows(int start, [int? end]);

  /// allRows return all rows, return null if something went wrong
  /// ```dart
  /// var rowsAll = await memory.allRows;
  /// ```
  Future<List<T>?> get allRows async => await subRows(0, length);

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

  /// getRowByID return object by id
  /// ```dart
  /// final obj = await memory.getRowByID('1');
  /// ```
  Future<T?> getRowByID(String id);

  /// setRow set row into memory and move row to first
  /// ```dart
  /// await memory.setRow(row);
  /// ```
  Future<void> setRow(T obj);
}
