import 'dart:async';
import 'dart:convert';
import 'package:libcli/assets.dart' as assets;

Map<String, dynamic> _libcliLocalization;

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
  if (_libcliLocalization == null) {
    String libJson = await assets.loadJson(
        'i18n/$languageCode/$countryCode/libcli.json',
        package: 'libcli');
    _libcliLocalization = json.decode(libJson);
  }
  localization.addAll(_libcliLocalization);
  return I18nState(localization);
}
