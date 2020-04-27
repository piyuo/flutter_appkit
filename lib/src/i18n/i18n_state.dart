import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/i18n.dart' as i18n;
import 'package:libcli/log.dart' as log;

const _here = 'i18n_state';

Map<String, dynamic> _globalLocalization = null;

String globalTranslate(String key) {
  if (_globalLocalization != null) {
    return _globalLocalization[key];
  }
  return null;
}

class I18nState {
  final Map<String, dynamic> _localization;

  I18nState(this._localization);

  String translate(String key) {
    var result = _localization[key];
    if (result == null) {
      return globalTranslate(key);
    }
    return result;
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
  if (_globalLocalization == null) {
    String libJson = await asset.loadJson(
        'i18n/$languageCode/$countryCode/lib.json',
        package: 'libcli');
    _globalLocalization = json.decode(libJson);
  }
  return _globalLocalization;
}

/// getTranslationFromAsset load translation from assets/i18n
///
Future<I18nState> getTranslationFromAsset(
    String filename, String languageCode, String countryCode) async {
  assert(filename != null);
  if (_globalLocalization == null) {
    _globalLocalization =
        await getTranslationFromLib(languageCode, countryCode);
    var json = log.toString(_globalLocalization);
    debugPrint('$_here~global localzation = $json');
  }

  var localization = Map<String, dynamic>();
  if (filename.isNotEmpty) {
    String pageJson = await asset
        .loadJson('i18n/$languageCode/$countryCode/${filename}.json');
    localization = json.decode(pageJson);
  }
  return I18nState(localization);
}

/// getTranslation load asset translation
///
Future<I18nState> getTranslation(String assetName) async {
  return await getTranslationFromAsset(
      assetName, i18n.languageCode, i18n.countryCode);
}
