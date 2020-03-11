import 'dart:async';
import 'dart:convert';
import 'package:libcli/hook/assets.dart' as assets;
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
  'i18n_state|read "i18n/${key}.json"'.print;
  String jsonContent = await assets.get('i18n/${key}.json');
  var localization = json.decode(jsonContent);
  return I18nState(localization);
}
