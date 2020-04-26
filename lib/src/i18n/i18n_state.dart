import 'dart:async';
import 'dart:convert';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/i18n.dart' as i18n;

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

/// getTranslationFromLib load lib.json, library predefine translation
///
Future<Map<String, dynamic>> getTranslationFromLib(
  String languageCode,
  String countryCode,
) async {
  if (_libLocalization == null) {
    String libJson = await asset.loadJson(
        'i18n/$languageCode/$countryCode/lib.json',
        package: 'libcli');
    _libLocalization = json.decode(libJson);
  }
  return _libLocalization;
}

/// getTranslationFromAsset load translation from assets/i18n
///
Future<I18nState> getTranslationFromAsset(
  String filename,
  String languageCode,
  String countryCode,
) async {
  assert(filename != null);
  Map<String, dynamic> localization;

  if (filename.isNotEmpty) {
    String pageJson = await asset
        .loadJson('i18n/$languageCode/$countryCode/${filename}.json');
    localization = json.decode(pageJson);
  } else {
    localization = Map<String, dynamic>();
  }
  localization.addAll(await getTranslationFromLib(languageCode, countryCode));
  return I18nState(localization);
}

/// getTranslation load asset translation
///
Future<I18nState> getTranslation(String assetName) async {
  return await getTranslationFromAsset(
      assetName, i18n.languageCode, i18n.countryCode);
}
