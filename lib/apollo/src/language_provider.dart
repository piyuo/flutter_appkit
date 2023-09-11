import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// _kPreferredLocaleKey is preferred locale key in storage
const _kPreferredLocaleKey = 'locale';

/// LanguageProvider provide a way to change locale
class LanguageProvider with ChangeNotifier {
  LanguageProvider({
    this.domain = '',
  });

  /// domain used to separate different app, in some app may user use different domain but same app, so we need separate them
  String domain;

  /// _storeKey is key in storage
  String get _storeKey => '$domain$_kPreferredLocaleKey';

  /// _limitSupportedLocales is subset of supported locales, used when backend only support part of app supported locales
  List<Locale>? _limitSupportedLocales;

  /// availableLocales return available locales
  List<Locale> get _availableLocales => _limitSupportedLocales ?? i18n.supportedLocales.toList();

  /// initWithPreferredLocale init with preferred locale
  Future<void> init() async {
    final savedLocale = await _readLocale();
    if (savedLocale != null) {
      if (!isLocaleAvailable(savedLocale)) {
        await _writeLocale(null);
        return;
      }

      if (i18n.preferLocale != savedLocale) {
        await i18n.setPreferLocale(savedLocale);
        notifyListeners();
      }
    }
  }

  /// changeLocale set preferred locale, it often used when user change locale in setting page
  Future<void> changeLocale(Locale? newLocale) async {
    if (await _writeLocale(newLocale)) {
      await i18n.setPreferLocale(newLocale);
      notifyListeners();
    }
  }

  /// limitSupportedLocales limit supported locales, this limit will not be saved in storage,
  /// need call this function every time when app start
  Future<void> limitSupportedLocales(List<Locale> limitLocales) async {
    _limitSupportedLocales = limitLocales;
    if (!isLocaleAvailable(i18n.locale)) {
      await i18n.setPreferLocale(availableLocales.first);
      notifyListeners();
      return;
    }
  }

  /// availableLocales return available locales, often used in display locales to user
  Iterable<Locale> get availableLocales {
    for (Locale locale in _availableLocales) {
      if (locale == i18n.locale) {
        _availableLocales.remove(locale);
        _availableLocales.insert(0, locale);
        break;
      }
    }
    return _availableLocales;
  }

  /// isLocaleAvailable check a locale is available or not
  bool isLocaleAvailable(Locale? aLocale) {
    for (Locale locale in _availableLocales) {
      if (locale == aLocale) {
        return true;
      }
    }
    return false;
  }

  /// _readLocale read saved locale from storage
  Future<Locale?> _readLocale() async {
    final localeTemp = await storage.getStringWithExp(_storeKey);
    if (localeTemp != null) {
      return i18n.stringToLocale(localeTemp);
    }
    return null;
  }

  /// _writeLocale write preferred locale to storage
  /// if user change one page's locale, other page need reflect change
  Future<bool> _writeLocale(Locale? newLocale) async {
    if (newLocale == null) {
      await storage.remove(_storeKey);
      return true;
    }

    if (!isLocaleAvailable(newLocale)) {
      return false;
    }

    await storage.setString(_storeKey, newLocale.toString());
    return true;
  }

  /// of get I18nProvider from context
  static LanguageProvider of(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false);
  }
}
