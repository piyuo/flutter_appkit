import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/provider.dart';
import 'package:libcli/src/i18n/global.dart';

const _here = 'i18n';

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

get currentLocale {
  if (_locale == null) {
    return Locale('en', 'US');
  }
  return _locale;
}

get currentLanguageCode => currentLocale.languageCode;

get currentCountryCode => currentLocale.countryCode;

get localeID => localeToId(currentLocale);

set locale(Locale locale) {
  _locale = locale;
  debugPrint('$_here~${STATE}set locale=$localeID');
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
  debugPrint('$_here~ask supported locales');
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
Locale determineLocale(List<Locale> locales) {
  Locale bestLocale;
  if (locales == null || locales.length == 0) {
    bestLocale = Locale('en', 'US');
    userPreferCountryCode = bestLocale.countryCode;
  } else {
    bestLocale = locales[0];
    userPreferCountryCode = bestLocale.countryCode;
    for (var locale in locales) {
      if (isSupportedLocale(locale)) {
        bestLocale = locale;
        break;
      }
    }
  }
  debugPrint('$_here~default country is $userPreferCountryCode, best locale is ${localeToId(bestLocale)}');
  return bestLocale;
}

class I18nDelegate extends LocalizationsDelegate<Locale> {
  @override
  bool isSupported(Locale locale) => isSupportedLocale(locale);

  @override
  Future<Locale> load(Locale l) async {
    locale = l;
    reloadGlobalTranslation(l.languageCode, l.countryCode);
    if (initDateFormatting != null) {
      //initDateFormatting(localeToId(l));
    }
    return l;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
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

/// initDateFormatting will set by configuration
///
///     i18n.initDateFormatting();
///
Function initDateFormatting;

/// withLocale run function in Intl zone
///
withLocale(Function() function) {
  Intl.withLocale(localeID, function);
}

/// timeToStr convert hour and minute to local string
///
String timeToStr(int hour, int minute) {
  var date = new DateTime.utc(2001, 1, 1, hour, minute);
  var str = '';
  withLocale(() {
    str = new DateFormat.jm().format(date);
  });
  return str;
}
