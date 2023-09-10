// ignore: implementation_imports
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../gen/lib_localizations.dart';
import '../gen/lib_localizations_en.dart';

//import 'package:libcli/eventbus/eventbus.dart' as eventbus;
/// LocaleChangedEvent happen when locale changed
//class LocaleChangedEvent {}
//  eventbus.broadcast(LocaleChangedEvent());

/// supportedLocales return i18n package supported locales
Iterable<Locale> supportedLocales = LibLocalizations.supportedLocales;

/// locale is current locale, it set by Intl.defaultLocale and may be override by preferLocale
Locale get locale => _preferLocale ?? stringToLocale(Intl.defaultLocale) ?? const Locale('en');

/// _appLocale is app locale, it set by _I18nDelegate
Locale? _appLocale;

/// _preferLocale is prefer locale, it set by user, if not null it will be override locale
Locale? _preferLocale;

/// preferLocale can set new prefer locale
Locale? get preferLocale => _preferLocale;

/// preferLocale will override locale, set null to disable override
set preferLocale(Locale? newLocale) {
  if (newLocale == null) {
    _preferLocale = null;
    Intl.defaultLocale = _appLocale?.toString();
    return;
  }
  _preferLocale = newLocale;
  Intl.defaultLocale = newLocale.toString();
  debugPrint('[i18n] locale=${Intl.defaultLocale}');
}

/// countryCode is current locale country code
String? get countryCode => locale.countryCode;

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
  Future<Locale> load(Locale newLocale) async {
    _appLocale = newLocale;
    if (_preferLocale != null) {
      return _preferLocale!;
    }
    if (Intl.defaultLocale != newLocale.toString()) {
      Intl.defaultLocale = newLocale.toString();
      debugPrint('[i18n] locale=${Intl.defaultLocale}');
    }
    return newLocale;
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
Locale? stringToLocale(String? value) {
  if (value == null) {
    return null;
  }

  var ids = value.split('_');
  if (ids.length > 1) return Locale(ids[0], ids[1]);
  return Locale(ids[0]);
}
