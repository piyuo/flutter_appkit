import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart';
import 'package:libcli/asset.dart' as asset;

const en_US = 'en_US';
const zh_CN = 'zh_CN';
const zh_TW = 'zh_TW';

//https://www.oracle.com/technical-resources/articles/javase/locale.html
const Locales = [
  en_US,
  zh_CN,
  zh_TW,
];
/*
  'en_CA',
  'en_GB',
  'en_AU',
  'ja_JP',
  'it_IT',
  'de_DE',

*/
Locale _locale = Locale('en', 'US');

/// userPreferCountryCode is  the first country code to determineLocale(), it mean user's default country
///
String userPreferCountryCode = 'US';

/// mockI18n Initializes the value for testing
///
///     I18nModel.mockI18n(Locale('en', 'US'), '{"title": "mock"}');
///
@visibleForTesting
void mockI18n(Locale locale, String map) {
  _locale = locale;
  // ignore:invalid_use_of_visible_for_testing_member
  asset.mock(map);
}

get currentLocale => _locale;

get currentLanguageCode => currentLocale.languageCode;

get currentCountryCode => currentLocale.countryCode;

get currentLocaleID => localeToId(currentLocale);

set locale(Locale locale) {
  _locale = locale;
  log('${COLOR_STATE}locale${COLOR_END}=$currentLocaleID');
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

/// askSupportedLocales ask what kind of locales we support
///
///
List<Locale> askSupportedLocales() {
  return Locales.map((id) => idToLocale(id)).toList();
}

/// isSupportedLocale check locale is supported?
///
///
bool isSupportedLocale(Locale locale) {
  var id = localeToId(locale);
  var result = Locales.contains(id);
  return result;
}

/// determineLocale select best locale for user and save user country to vars
///
/// https://api.flutter.dev/flutter/widgets/LocaleListResolutionCallback.html
///
/// The locales list is the device's preferred locales when the app started, or the device's preferred locales the user selected after the app was started. This list is in order of preference. If this list is null or empty, then Flutter has not yet received the locale information from the platform.
///
Locale determineLocale(List<Locale>? locales) {
  Locale bestLocale = Locale('en', 'US');
  if (locales != null && locales.length > 0) {
    bestLocale = locales[0];
    userPreferCountryCode = bestLocale.countryCode ?? 'US';
    for (var locale in locales) {
      if (isSupportedLocale(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  //best locale: ${localeToId(bestLocale)}
  log('${COLOR_STATE}country${COLOR_END}=$userPreferCountryCode');
  return bestLocale;
}

class I18nDelegate extends LocalizationsDelegate<Locale> {
  @override
  bool isSupported(Locale locale) => isSupportedLocale(locale);

  @override
  Future<Locale> load(Locale l) async {
    locale = l;
    //no need for now, cause GlobalLocalizations will load date formatting
    //if (initDateFormatting != null) {
    //initDateFormatting(localeToId(l));
    //}
    return l;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
