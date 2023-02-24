// ignore: implementation_imports
import 'package:protobuf/src/protobuf/mixins/well_known.dart' as google_mixin;
import 'package:libcli/google/google.dart' as google;
import 'datetime.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../gen/lib_localizations.dart';
import '../gen/lib_localizations_en.dart';

/// supportedLocales return i18n package supported locales
Iterable<Locale> supportedLocales = LibLocalizations.supportedLocales;

/// localizationsDelegates return i18n package localizations delegates
Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
  _I18nDelegate(),
  LibLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

/// _I18nDelegate used to get localized change events
class _I18nDelegate extends LocalizationsDelegate<Locale> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<Locale> load(Locale locale) async {
    Intl.defaultLocale = locale.toString();
    debugPrint('[i18n] locale=${Intl.defaultLocale}');
    return locale;
  }

  @override
  bool shouldReload(_I18nDelegate old) => false;
}

extension I18nString on String {
  /// replace1 replace %1 to value
  /// ```dart
  /// str.replace1('value1');
  /// ```
  String replace1(String value) => replaceAll('%1', value);

  /// replace2 replace %1 to value1 and %2 to value2
  /// ```dart
  /// str.replace2('value1','value2');
  /// ```
  String replace2(String value1, String value2) => replaceAll('%1', value1).replaceAll('%2', value2);

  /// replace2 replace %1 to value1 and %2 to value2 and %3 to value3
  /// ```dart
  /// str.replace3('value1','value2','value3');
  /// ```
  String replace3(String value1, String value2, String value3) =>
      replaceAll('%1', value1).replaceAll('%2', value2).replaceAll('%3', value3);
}

extension I18nBuildContext on BuildContext {
  /// i18n return AppLocalizations of current context
  LibLocalizations get i18n => Localizations.of<LibLocalizations>(this, LibLocalizations) ?? LibLocalizationsEn();
}

/// localeName return current locale name
String get localeName => Intl.defaultLocale ?? 'en';

/// localeName return current locale name
//set localeName(String value) => Intl.defaultLocale = value;

/// locale is current locale, it set by Intl.defaultLocale
Locale get locale => stringToLocale(localeName);

/// setLocale override current locale
void setLocale(String newLocaleName) {
  Intl.defaultLocale = newLocaleName;
}

/// mockLocale mock intl default locale
@visibleForTesting
void mockLocale(String newLocaleName) => Intl.defaultLocale = newLocaleName;

/// countryCode is current locale country code
String get countryCode => locale.countryCode ?? 'US';

/// withLocale run function in Intl zone
withLocale(String newLocaleName, Function() function) {
  Intl.withLocale(newLocaleName, function);
}

/// localeToAcceptLanguage convert Locale(''en,'US') to 'en-US', use by command http header
/// ```dart
/// var id = localeToAcceptLanguage(Locale('en','US'));
/// ```
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

/// timestamp create TimeStamp and convert datetime to utc, if datetime is null use DateTime.now()
/// ```dart
/// var t = timestamp();
/// ```
google.Timestamp timestamp({
  DateTime? datetime,
}) {
  datetime = datetime ?? DateTime.now();
  return google.Timestamp.fromDateTime(datetime.toUtc());
}

/// I18nTime add time function to TimeStamp
extension I18nTime on google.Timestamp {
  /// local return local datetime
  /// ```dart
  /// var d = DateTime(2021, 1, 2, 23, 30);
  /// var t = timestamp();
  /// t.local = d;
  /// expect(t.local, d);
  /// ```
  DateTime get local {
    return toDateTime().toLocal();
  }

  /// local set local datetime
  /// ```dart
  /// var d = DateTime(2021, 1, 2, 23, 30);
  /// var t = timestamp();
  /// t.local = d;
  /// expect(t.local, d);
  /// ```
  set local(DateTime d) {
    google_mixin.TimestampMixin.setFromDateTime(this, d.toUtc());
  }

  /// localDateString return local date string in current locale
  /// ```dart
  /// expect(t.localDateString, 'Jan 2, 2021');
  /// ```
  String get localDateString {
    return formatDate(local);
  }

  /// localDateTimeString return local date time string in current locale
  /// ```dart
  /// expect(t.localTimeString, '11:30 PM');
  /// ```
  String get localDateTimeString {
    return formatDateTime(local);
  }

  /// localDateString return local time string in current locale
  /// ```dart
  /// expect(t.localDateTimeString, 'Jan 2, 2021 11:30 PM');
  /// ```
  String get localTimeString {
    return formatTime(local);
  }
}

/*
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

*/
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
