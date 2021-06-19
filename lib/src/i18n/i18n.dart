import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/asset.dart' as asset;

const US = 'US';
const CN = 'CN';
const TW = 'TW';
const en_US = 'en_' + US;
const zh_CN = 'zh_' + CN;
const zh_TW = 'zh_' + TW;

/// supportLocales define supported locale
//https://www.oracle.com/technical-resources/articles/javase/locale.html
const _supportLocales = [
  en_US,
  zh_CN,
  zh_TW,
];

/// _locale is current locale, it set by determineLocale()
Locale _locale = Locale('en', US);

Locale get locale => _locale;

String get localeString => localeToString(_locale);

set locale(Locale value) {
  _locale = value;
  final str = localeToString(value);
  log.log('${log.COLOR_STATE}locale${log.COLOR_END}=$str');
}

/// localeToString convert Locale(''en,'US') to 'en_US'
///
/// var id = localeToId(Locale('en','US'));
///
String localeToString(Locale value) {
  return '${value.languageCode}_${value.countryCode}';
}

/// stringToLocale 'en_US' to Locale(''en,'US')
///
Locale stringToLocale(String value) {
  var ids = value.split('_');
  if (ids.length > 1) return Locale(ids[0], ids[1]);
  return Locale(ids[0]);
}

/// _country is current country, it set by first country code in determineLocale(), it mean user's default country
///
String _country = US;

String get country => _country;

set country(String value) {
  _country = value;
  log.log('${log.COLOR_STATE}country${log.COLOR_END}=$value');
}

/// isCountryCN return true if country is china, we may need show different map or import different service cause china's firewall
get isCountryCN => _country == CN;

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

/// mock a locale
///
///     mock(Locale('en', 'US'), '{"title": "mock"}');
///
@visibleForTesting
void mock(Locale locale, String map) {
  _locale = locale;
  // ignore:invalid_use_of_visible_for_testing_member
  asset.mock(map);
}

/// askSupportedLocales ask what kind of locales we support
///
List<Locale> askSupportedLocales() {
  return _supportLocales.map((id) => stringToLocale(id)).toList();
}

/// isSupportedLocale check locale is supported?
///
///
bool isSupportedLocale(Locale locale) {
  var id = localeToString(locale);
  var result = _supportLocales.contains(id);
  return result;
}

/// determineLocale select best locale for user and save user country to vars
///
/// https://api.flutter.dev/flutter/widgets/LocaleListResolutionCallback.html
///
/// The locales list is the device's preferred locales when the app started, or the device's preferred locales the user selected after the app was started. This list is in order of preference. If this list is null or empty, then Flutter has not yet received the locale information from the platform.
///
Locale determineLocale(List<Locale>? locales) {
  Locale bestLocale = Locale('en', US);
  if (locales != null && locales.length > 0) {
    bestLocale = locales[0];
    _country = bestLocale.countryCode ?? US;
    for (var locale in locales) {
      if (isSupportedLocale(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  //best locale: ${localeToId(bestLocale)}
  log.log('${log.COLOR_STATE}country${log.COLOR_END}=$_country');
  return bestLocale;
}
