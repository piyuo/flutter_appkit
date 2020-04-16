import 'dart:async';
import 'dart:convert';
import 'package:libcli/src/common/assets.dart' as assets;

Map<String, dynamic> _libLocalization = null;

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

/// readLibTranslation load lib.json, library predefine translation
///
Future<Map<String, dynamic>> readLibTranslation(
  String languageCode,
  String countryCode,
) async {
  if (_libLocalization == null) {
    String libJson = await assets.loadJson(
        'i18n/$languageCode/$countryCode/lib.json',
        package: 'libcli');
    _libLocalization = json.decode(libJson);
  }
  return _libLocalization;
}

/// readPageTranslation load page's  translation
///
Future<I18nState> readPageTranslation(
  String page,
  String languageCode,
  String countryCode,
) async {
  assert(page != null);
  Map<String, dynamic> localization;

  if (page.isNotEmpty) {
    String pageJson =
        await assets.loadJson('i18n/$languageCode/$countryCode/${page}.json');
    localization = json.decode(pageJson);
  } else {
    localization = Map<String, dynamic>();
  }
  localization.addAll(await readLibTranslation(languageCode, countryCode));
  return I18nState(localization);
}
