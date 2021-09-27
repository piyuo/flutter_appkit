import 'dart:core';
import 'package:libcli/i18n.dart' as i18n;

class Registry {
  Registry({
    this.key = '',
    this.expired,
    this.length = 0,
  });

  String key;

  int length;

  DateTime? expired;

  Map<String, dynamic>? toJsonMap() {
    final result = {
      'k': key,
      'l': length,
    };
    if (expired != null) {
      result['e'] = i18n.formatStandardDate(expired!);
    }
    return result;
  }

  void fromJsonMap(Map<String, dynamic> map) {
    key = map['k'];
    length = map['l'];
    if (map.keys.contains('e')) {
      expired = i18n.parseStandardDate(map['e']);
    }
  }
}
