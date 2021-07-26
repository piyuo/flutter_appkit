import 'package:flutter/widgets.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/pref.dart' as pref;
import 'package:libcli/eventbus.dart' as eventbus;

const PREF_LOCALE_KEY = 'LOCALE';
const US = 'US';
const CN = 'CN';
const TW = 'TW';
const en_US = 'en_' + US;
const zh_CN = 'zh_' + CN;
const zh_TW = 'zh_' + TW;

/// _supportedLocales define supported locale
//https://www.oracle.com/technical-resources/articles/javase/locale.html
const _supportedLocales = [
  en_US,
  zh_CN,
  zh_TW,
];

/// _locale is current locale, it set by determineLocale()
Locale _locale = Locale('en', US);

String get localeString => localeToString(_locale);

Locale get locale => _locale;

class I18nChangedEvent extends eventbus.Event {}

/// localeToAcceptLanguage convert Locale(''en,'US') to 'en-US', use by command http header
///
/// var id = localeToAcceptLanguage(Locale('en','US'));
///
String localeToAcceptLanguage(Locale value) {
  return '${value.languageCode}-${value.countryCode}';
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
  log.log('country=$value');
}

/// isCountryCN return true if country is china, we may need show different map or import different service cause china's firewall
get isCountryCN => _country == CN;

class LocaleDelegate extends LocalizationsDelegate<Locale> {
  bool _isChanged = false;

  @override
  bool isSupported(Locale locale) => isLocaleSupported(locale);

  @override
  Future<Locale> load(Locale newLocale) async {
    // check pref first
    final preferLocaleStr = await pref.getStringWithExp(PREF_LOCALE_KEY);
    if (preferLocaleStr.isNotEmpty) {
      _locale = stringToLocale(preferLocaleStr);
    } else {
      _locale = newLocale;
      //no need for now, cause GlobalLocalizations will load date formatting
      //if (initDateFormatting != null) {
      //initDateFormatting(localeToId(l));
      //}
    }
    log.log('locale=${localeToString(_locale)}');
    return _locale;
  }

  @override
  bool shouldReload(LocaleDelegate old) => _isChanged;
}

/// setLocale override locale, return true if locale actually changed, we always use system locale but if user choose override it will effect for 24 hours
Future<bool> setLocale(
  BuildContext context,
  Locale value, {
  bool remember: false,
}) async {
  if (value.countryCode != _locale.countryCode || value.languageCode != _locale.languageCode) {
    _locale = value;
    final localeStr = localeToString(value);
    if (remember) {
      final tomorrow = DateTime.now().add(Duration(hours: 24));
      await pref.setStringWithExp(PREF_LOCALE_KEY, localeStr, tomorrow);
    }
    log.log('locale=$localeStr');
    await eventbus.broadcast(context, I18nChangedEvent());
    return true;
  }
  return false;
}

/// mock a locale
///
///     mock(Locale('en', 'US'), '{"title": "mock"}');
///
//@visibleForTesting
//void mock(Locale locale, String map) {
//  _locale = locale;
// ignore:invalid_use_of_visible_for_testing_member
//  asset.mock(map);
//}

/// askSupportedLocales ask what kind of locales we support
///
List<Locale> askSupportedLocales() {
  return _supportedLocales.map((id) => stringToLocale(id)).toList();
}

/// isLocaleSupported check locale is supported
///
///
bool isLocaleSupported(Locale locale) {
  var id = localeToString(locale);
  return _supportedLocales.contains(id);
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
      if (isLocaleSupported(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  //best locale: ${localeToId(bestLocale)}
  log.log('country=$_country');
  return bestLocale;
}
