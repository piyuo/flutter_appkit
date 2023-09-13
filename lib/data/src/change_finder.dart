import 'package:libcli/net/net.dart' as net;

/// ChangeFinder find how many data has been changed
class ChangeFinder<T extends net.Object> {
  /// insertCount is number of data has been inserted, use for refresh
  int insertCount = 0;

  /// removed keep removed data, use for refresh
  Map<int, T> removed = {};

  /// isChanged return true if data has been changed
  bool get isChanged => insertCount > 0 || removed.isNotEmpty;

  /// Convert the source list into a set for efficient lookup
  Set<T> convertToSet(List<T> list) {
    return Set.from(list);
  }

  /// RefreshDifference finds differences when refreshing between source and target
  /// removed is a map of index to the removed item, it sort by source index
  void refreshDifference({required List<T> source, required List<T> target}) {
    // Convert the source list to a set for efficient lookup
    var sourceSet = convertToSet(source);

    for (var t in target) {
      if (!sourceSet.contains(t)) {
        insertCount++;
      }
    }

    for (int i = 0; i < source.length; i++) {
      if (!target.contains(source[i])) {
        removed[i] = source[i];
      }
    }
  }
}
