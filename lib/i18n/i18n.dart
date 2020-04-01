import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/hook/assets.dart' as assets;
import 'package:libcli/i18n/i18n_provider.dart';
import 'package:flutter/foundation.dart';

const _here = 'i18n';

//https://www.oracle.com/technical-resources/articles/javase/locale.html
const Locales = [
  'en_US',
  'en_CA',
  'en_GB',
  'en_AU',
  'zh_CN',
  'zh_TW',
  'zh_TW',
  'zh_TW',
  'zh_TW',
  'ja_JP',
  'it_IT',
  'de_DE',
];

String _localeID;

/// mockInit Initializes the value for testing
///
///     I18nModel.mockInit('{"title": "mock"}');
///
@visibleForTesting
void mockInit(String map) {
  _localeID = 'mockLocale';
  assets.mockInit(map);
}

get localeID => _localeID;

set localeID(String value) {
  _localeID = value;
  debugPrint('$_here|set locale=$_localeID');
}

bool isSupportedLocale(Locale locale) {
  var id = localeToId(locale);
  var result = Locales.contains(id);
  return result;
}

String localeToId(Locale locale) {
  return '${locale.languageCode}_${locale.countryCode}';
}

Locale idToLocale(String id) {
  var ids = id.split('_');
  if (ids.length > 1) return Locale(ids[0], ids[1]);
  return Locale(ids[0]);
}

Locale determineLocale(List<Locale> locales) {
  for (var locale in locales) {
    if (isSupportedLocale(locale)) {
      debugPrint(
          '$_here|determinie ${locale.languageCode}_${locale.countryCode}');
      return locale;
    }
  }
  var locale = idToLocale(Locales[0]);
  debugPrint('$_here|use default ${locale.languageCode}_${locale.countryCode}');
  return locale;
}

List<Locale> supportedLocales() {
  debugPrint('$_here|ask supported locales');
  return Locales.map((id) => idToLocale(id)).toList();
}

//This will allow you to add `.i18n` to your strings
extension Localization on String {
  String i18n(BuildContext context) {
    var provider = Provider.of<I18nProvider>(context);
    assert(provider != null, 'I18nProvider need inject in context');
    return provider.translate(this);
  }
}
