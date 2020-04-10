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

Future<I18nState> readState(
    String page, String languageCode, String countryCode) async {
  assert(page.length > 0);
  String pageJson =
      await assets.loadJson('i18n/$languageCode/$countryCode/${page}.json');
  Map<String, dynamic> localization = json.decode(pageJson);
  String libJson = await assets.loadJson(
      'i18n/$languageCode/$countryCode/libcli.json',
      package: 'libcli');
  var libLocalization = json.decode(libJson);
  localization.addAll(libLocalization);
  return I18nState(localization);
}
