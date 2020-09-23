import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/i18n-provider.dart';
import 'package:libcli/src/i18n/i18n-global.dart';

const _here = 'i18n';

//https://www.oracle.com/technical-resources/articles/javase/locale.html
const Locales = [
  'en-US',
  'zh-CN',
  'zh-TW',
];
/*
  'en-US',
  'en-CA',
  'en-GB',
  'en-AU',
  'zh-CN',
  'zh-TW',
  'zh-TW',
  'zh-TW',
  'zh-TW',
  'ja-JP',
  'it-IT',
  'de-DE',

*/
Locale _locale;

/// userPreferCountryCode is  the first country code to determineLocale(), it mean user's default country
///
String userPreferCountryCode;

/// mockI18n Initializes the value for testing
///
///     I18nModel.mockI18n(Locale('en', 'US'), '{"title": "mock"}');
///
@visibleForTesting
void mockI18n(Locale locale, String map) {
  _locale = locale;
  // ignore:invalid_use_of_visible_for_testing_member
  asset.mockAssetsByString(map);
}

get locale {
  if (_locale == null) {
    return Locale('en', 'US');
  }
  return _locale;
}

get languageCode => locale.languageCode;

get countryCode => locale.countryCode;

get localeID => '${locale.languageCode}-${locale.countryCode}';

set locale(Locale locale) {
  _locale = locale;
  debugPrint('$_here~${STATE}set locale=$localeID');
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
  return '${locale.languageCode}-${locale.countryCode}';
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
  userPreferCountryCode = firstLocale.countryCode;
  debugPrint(
      '$_here~default country is $userPreferCountryCode, best locale is ${bestLocale.languageCode}-${bestLocale.countryCode}');
  return bestLocale;
}

List<Locale> supportedLocales() {
  debugPrint('$_here~ask supported locales');
  return Locales.map((id) => idToLocale(id)).toList();
}

//This will allow you to add `.i18n` to your strings
extension Localization on String {
  String get i18n_ {
    return globalTranslate(this);
  }

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
