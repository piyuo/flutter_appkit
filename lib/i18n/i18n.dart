import 'package:libcli/log/log.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/assets.dart' as assets;
import 'package:libcli/hook/vars.dart' as vars;
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

Locale _locale;

/// mockInit Initializes the value for testing
///
///     I18nModel.mockInit('{"title": "mock"}');
///
@visibleForTesting
void mock(Locale locale, String map) {
  _locale = locale;
  assets.mockString(map);
}

get locale => _locale;

get languageCode => _locale.languageCode;

get countryCode => _locale.countryCode;

get localeID => '${_locale.languageCode}_${_locale.countryCode}';

set locale(Locale locale) {
  _locale = locale;
  debugPrint('$_here~set locale=$localeID');
}

bool isSupportedLocale(Locale locale) {
  var id = localeToId(locale);
  var result = Locales.contains(id);
  return result;
}

/// localeToId convert Locale(''en,'US') to 'en_US'
///
/// var id = localeToId(Locale('en','US'));
String localeToId(Locale locale) {
  return '${locale.languageCode}_${locale.countryCode}';
}

Locale idToLocale(String id) {
  var ids = id.split('_');
  if (ids.length > 1) return Locale(ids[0], ids[1]);
  return Locale(ids[0]);
}

/// determineLocale select best locale for user and save user country to vars
///
///https://api.flutter.dev/flutter/widgets/LocaleListResolutionCallback.html
///
///The locales list is the device's preferred locales when the app started, or the device's preferred locales the user selected after the app was started. This list is in order of preference. If this list is null or empty, then Flutter has not yet received the locale information from the platform.
///
Locale determineLocale(List<Locale> locales) {
  Locale firstLocale;
  Locale bestLocale;
  if (locales == null || locales.length == 0) {
    firstLocale = bestLocale = Locale('en', 'US');
  } else {
    firstLocale = bestLocale = locales[0];
    for (var locale in locales) {
      if (isSupportedLocale(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  vars.country = firstLocale.countryCode;
  debugPrint(
      '$_here~set locale=$NOUN${bestLocale.languageCode}_${bestLocale.countryCode}');
  return bestLocale;
}

List<Locale> supportedLocales() {
  debugPrint('$_here~ask supported locales');
  return Locales.map((id) => idToLocale(id)).toList();
}

//This will allow you to add `.i18n` to your strings
extension Localization on String {
  String i18n(BuildContext context) {
    if (!kReleaseMode) {
      // allow null context in test
      if (context == null) {
        return this;
      }
    }
    var provider = Provider.of<I18nProvider>(context, listen: false);
    assert(provider != null, 'I18nProvider need inject in context');
    return provider.translate(this);
  }
}
