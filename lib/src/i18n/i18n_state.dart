import 'dart:async';
import 'dart:convert';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/i18n.dart' as i18n;
import 'package:libcli/src/i18n/i18n_global.dart';

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

/// getTranslationFromAsset load translation from assets/i18n
///
Future<I18nState> getTranslation(String filename) async {
  var localization = Map<String, dynamic>();
  if (filename != null && filename.isNotEmpty) {
    String pageJson = await asset.loadJson(
        'i18n/${i18n.languageCode}/${i18n.countryCode}/${filename}.json');
    localization = json.decode(pageJson);
  }
  return I18nState(localization);
}
