import 'dart:async';
import 'dart:convert';
import 'package:libcli/assets/assets.dart' as assets;
import 'package:libcli/log/log.dart';

class I18nState {
  final Map<String, dynamic> _localization;

  I18nState(this._localization);

  String translate(String key) {
    return _localization[key];
  }

  Map toJson() {
    return {'localization': _localization};
  }
}

Future<I18nState> readState(String key) async {
  assert(key.length > 0);
  String jsonContent = await assets.get('i18n/${key}.json');
  'i18n|load $key'.print;
  var localization = json.decode(jsonContent);
  return I18nState(localization);
}
