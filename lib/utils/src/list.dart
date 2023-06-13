/// SplitList provide split method for List
extension SplitList<T> on List<T> {
  /// splitList split long list into sublist
  List<List<T>> split(int sublistSize) {
    int numberOfSubLists = (length / sublistSize).ceil();
    return List.generate(numberOfSubLists, (index) {
      int startIndex = index * sublistSize;
      int endIndex = (index + 1) * sublistSize;
      return sublist(startIndex, endIndex < length ? endIndex : length);
    });
  }
}
