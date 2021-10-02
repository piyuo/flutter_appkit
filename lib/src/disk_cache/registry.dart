import 'dart:core';
import 'package:libcli/pb.dart' as i18n;
import 'registries.dart';

class Registry {
  Registry({
    required this.key,
    required this.size,
    required this.expired,
  });

  /// key must be unique in entire cache
  String key;

  /// cachedLength is cached string length
  int size;

  /// expired date, every registry must have a expired date
  DateTime expired;

  /// storageKey is key use to storage
  String get storageKey => cached_key + '_' + key;

  /// toJsonMap convert registry to json map
  Map<String, dynamic>? toJsonMap() {
    return {
      'k': key,
      'l': size,
      'e': i18n.formatDate(expired),
    };
  }

  /// Registry.fromJson factory constructor for JSON
  factory Registry.fromJson(Map<String, dynamic> map) =>
      Registry(key: '', size: 0, expired: DateTime.fromMicrosecondsSinceEpoch(0))..fromJsonMap(map);

  /// fromJsonMap load json map and set to registry
  void fromJsonMap(Map<String, dynamic> map) {
    key = map['k'];
    size = map['l'];
    expired = i18n.parseDate(map['e']);
  }
}
