import 'package:libcli/pb/pb.dart' as pb;

/// Query can use in filter to query rows
abstract class Query<T extends pb.Object> {
  /// ```dart
  /// query.isMatch(row);
  /// ```
  bool isMatch(T source);
}

/// FullTextQuery will keep rows that match the keyword
/// ```dart
/// final query = FullTextQuery('world');
/// ```
class FullTextQuery<T extends pb.Object> extends Query<T> {
  /// FullTextQuery will keep rows that match the keyword
  /// ```dart
  /// final query = FullTextQuery('world');
  /// ```
  FullTextQuery(this._keyword);

  /// _keyword is keyword to match
  final String _keyword;

  @override
  bool isMatch(T source) {
    return source.toString().toLowerCase().contains(_keyword.toLowerCase());
  }
}
