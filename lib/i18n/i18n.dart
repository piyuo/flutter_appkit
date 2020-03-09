import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/assets/assets.dart' as assets;
import 'package:provider/provider.dart';
import 'package:libcli/i18n/i18n_provider.dart';

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
  Future<String> mockLoad(fileName) async {
    return map;
  }

  _localeID = 'mockLocale';
  assets.get = mockLoad;
}

get localeID => _localeID;

set localeID(String value) {
  _localeID = value;
  '$_here|set locale=$_localeID'.print;
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
  '$_here|determine best locale'.print;
  print('determine Locale');
  for (var locale in locales) {
    if (isSupportedLocale(locale)) {
      '$_here|choose ${locale.languageCode}_${locale.countryCode}'.print;
      return locale;
    }
  }
  var locale = idToLocale(Locales[0]);
  '$_here|use default ${locale.languageCode}_${locale.countryCode}'.print;
  return locale;
}

List<Locale> supportedLocales() {
  '$_here|ask supported locales'.print;
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
