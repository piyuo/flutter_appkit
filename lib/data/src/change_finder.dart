import 'package:libcli/pb/pb.dart' as pb;

/// ChangeFinder find how many data has been changed
class ChangeFinder<T extends pb.Object> {
  int insertCount = 0;
  Map<int, T> removed = {};

  /// Convert the source list into a set for efficient lookup
  Set<T> convertToSet(List<T> list) {
    return Set.from(list);
  }

  /// RefreshDifference finds differences when refreshing between source and target
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
/*class ChangeFinder<T extends pb.Object> {
  /// insertCount is number of data has been inserted, use for refresh
  int insertCount = 0;

  /// removed keep removed data, use for refresh
  /// key is index of data in list
  /// value is data
  Map<int, T> removed = {};

  /// inInList return true if t is in list
  bool isInList(List<T> list, T t) {
    return list.where((row) => t.id == row.id && t.utcTime == row.utcTime).isNotEmpty;
  }

  /// refreshDifference find difference when refresh between source and target
  void refreshDifference({required List<T> source, required List<T> target}) {
    for (var t in target) {
      if (!isInList(source, t)) {
        insertCount++;
      }
    }

    for (int i = 0; i < source.length; i++) {
      if (!isInList(target, source[i])) {
        removed[i] = source[i];
      }
    }
  }
}
*/