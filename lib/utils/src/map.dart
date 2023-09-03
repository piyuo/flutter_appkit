/// Copy on map will allow you to add [.deepCopy] to your strings
extension Copy on Map {
  /// deepCopy clone entire map include child to new map
  /// ```dart
  /// var newState = oldState.deepCopy();
  /// ```
  Map deepCopy() {
    return _copyDeepMap(this);
  }

  /// _copyDeepMap copy map to new map
  /// ```dart
  /// var newMap =  _copyDeepMap(map);
  /// ```
  Map _copyDeepMap(Map map) {
    Map newMap = {};
    map.forEach((key, value) {
      newMap[key] = value is Map ? _copyDeepMap(value) : value;
    });
    return newMap;
  }
}
