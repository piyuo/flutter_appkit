import 'dart:async';
import 'dart:convert';
import 'package:libcli/data/assets.dart' as assets;

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
  String jsonContent = await assets.loadJson('i18n/${key}.json');

  var localization = json.decode(jsonContent);
  return I18nState(localization);
}
