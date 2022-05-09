import 'package:libcli/pb/pb.dart' as pb;

/// Filter use isMatch to filter row
/// ```dart
/// filter.isMatch(row);
/// ```
abstract class Filter<T extends pb.Object> {
  /// isMatch return true if source match filter
  /// ```dart
  /// filter.isMatch(row);
  /// ```
  bool isMatch(T source);
}

/// FullTextFilter will keep rows that match the keyword
/// ```dart
/// final filter = FullTextFilter('world');
/// ```
class FullTextFilter<T extends pb.Object> extends Filter<T> {
  /// FullTextFilter will keep rows that match the keyword
  /// ```dart
  /// final filter = FullTextFilter('world');
  /// ```
  FullTextFilter(this._keyword);

  /// _keyword is keyword to match
  final String _keyword;

  @override
  bool isMatch(T source) {
    return source.toString().toLowerCase().contains(_keyword.toLowerCase());
  }
}
