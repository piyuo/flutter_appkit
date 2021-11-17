import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/pref/pref.dart' as pref;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../gen/app_localizations.dart';

class L10nProvider with ChangeNotifier {
  Locale get currentLocale => locale;

  set currentLocale(Locale newLocale) {
    setLocale(newLocale.toString());
    notifyListeners();
  }

  static L10nProvider of(BuildContext context) {
    return Provider.of<L10nProvider>(context, listen: false);
  }

  Iterable<Locale> supportedLocales = AppLocalizations.supportedLocales;

  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates = [
    LocaleDelegate(),
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

const prefLocaleKey = 'locale';
/*
const us = 'US';
const cn = 'CN';
const tw = 'TW';
const enUS = 'en_' + us;
const zhCN = 'zh_' + cn;
const zhTW = 'zh_' + tw;
/// _supportedLocales define supported locale
//https://www.oracle.com/technical-resources/articles/javase/locale.html
const _supportedLocales = [
  enUS,
  zhCN,
  zhTW,
];
*/
/// localeName return current locale name
String get localeName => Intl.defaultLocale ?? 'en_US';

/// locale is current locale, it set by Intl.defaultLocale
Locale get locale => stringToLocale(localeName);

/// countryCode is current locale country code
String get countryCode => locale.countryCode ?? 'US';

/// withLocale run function in Intl zone
///
withLocale(String newLocaleName, Function() function) {
  Intl.withLocale(newLocaleName, function);
}

/// setLocale override locale, return true if locale actually changed, we always use system locale but if user choose override it will effect for 24 hours
Future<bool> setLocale(
  String newLocaleName, {
  BuildContext? context,
  bool remember = false,
}) async {
  if (newLocaleName != localeName) {
    Intl.defaultLocale = newLocaleName;

    if (remember) {
      final tomorrow = DateTime.now().add(const Duration(hours: 24));
      await pref.setStringWithExp(prefLocaleKey, newLocaleName, tomorrow);
    }
    log.log('[i18n] locale=$newLocaleName');
    if (context != null) {
      await eventbus.broadcast(context, I18nChangedEvent());
    }
    return true;
  }
  return false;
}

class I18nChangedEvent extends eventbus.Event {}

/// localeToAcceptLanguage convert Locale(''en,'US') to 'en-US', use by command http header
///
/// var id = localeToAcceptLanguage(Locale('en','US'));
///
String localeToAcceptLanguage(Locale value) {
  return '${value.languageCode}-${value.countryCode}';
}

/// stringToLocale 'en_US' to Locale(''en,'US')
///
Locale stringToLocale(String value) {
  var ids = value.split('_');
  if (ids.length > 1) return Locale(ids[0], ids[1]);
  return Locale(ids[0]);
}

/*
/// _country is current country, it set by first country code in determineLocale(), it mean user's default country
///
String _country = 'US';

String get country => _country;

set country(String value) {
  _country = value;
  log.log('[i18n] country=$value');
}
/// isCountryCN return true if country is china, we may need show different map or import different service cause china's firewall
get isCountryCN => _country == 'CN';
*/

class LocaleDelegate extends LocalizationsDelegate<Locale> {
  @override
  bool isSupported(Locale locale) {
    return (locale.languageCode == 'en' && locale.countryCode == 'US') ||
        (locale.languageCode == 'zh' && locale.countryCode == 'CN') ||
        (locale.languageCode == 'zh' && locale.countryCode == 'TW');
  }

  @override
  Future<Locale> load(Locale locale) async {
    // check pref first
    final preferLocaleStr = await pref.getStringWithExp(prefLocaleKey);
    Intl.defaultLocale = preferLocaleStr.isNotEmpty ? preferLocaleStr : Intl.defaultLocale = locale.toString();
    //no need for now, cause GlobalLocalizations will load date formatting
    //if (initDateFormatting != null) {
    //initDateFormatting(localeToId(l));
    //}
    log.log('[i18n] init ${Intl.defaultLocale}');
    return stringToLocale(Intl.defaultLocale!);
  }

  @override
  bool shouldReload(LocaleDelegate old) => false;
}
/*
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
  Locale bestLocale = const Locale('en', us);
  if (locales != null && locales.isNotEmpty) {
    bestLocale = locales[0];
    _country = bestLocale.countryCode ?? us;
    for (var locale in locales) {
      if (isLocaleSupported(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  //best locale: ${localeToId(bestLocale)}
  log.log('[i18n] country=$_country');
  return bestLocale;
}
*/