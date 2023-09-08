import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// _kPreferredLocaleKey is preferred locale key in storage
const _kPreferredLocaleKey = 'locale';

/// LanguageProvider provide a way to change locale
class LanguageProvider with ChangeNotifier {
  LanguageProvider(this._locales);

  /// _locales is supported locales
  List<Locale> _locales;

  /// _preferredLocale is user preferred locale
  Locale? _preferredLocale;

  /// preferredLocale return preferred locale
  Locale? get preferredLocale => _preferredLocale;

  /// initWithPreferredLocale init with preferred locale
  Future<void> init() async {
    _preferredLocale = await loadPreferredLocale();
    if (_preferredLocale != null && !isLocaleValid(_preferredLocale!)) {
      await setPreferredLocale(null);
      return;
    }
    notifyListeners();
  }

  /// setLocales set supported locales
  Future<void> setLocales(List<Locale> newLocales) async {
    _locales = newLocales;
    if (_preferredLocale != null && !isLocaleValid(_preferredLocale!)) {
      _preferredLocale = null;
      await setPreferredLocale(null);
    }
    notifyListeners();
  }

  /// supportedLocales return supported locales
  Iterable<Locale> get supportedLocales {
    if (_preferredLocale != null && _preferredLocale != _locales.first) {
      // move preferred locale to first
      for (Locale locale in _locales) {
        if (locale == _preferredLocale!) {
          _locales.remove(locale);
          _locales.insert(0, _preferredLocale!);
          break;
        }
      }
    }
    return _locales;
  }

  /// isLocaleValid check a locale is valid
  bool isLocaleValid(Locale aLocale) {
    for (Locale locale in _locales) {
      if (locale == aLocale) {
        return true;
      }
    }
    return false;
  }

  /// loadPreferredLocale load preferred locale from storage
  Future<Locale?> loadPreferredLocale() async {
    final localeTemp = await storage.getStringWithExp(_kPreferredLocaleKey);
    if (localeTemp != null) {
      return i18n.stringToLocale(localeTemp);
    }
    return null;
  }

  /// overrideLocaleTemporary override locale for 24 hour, cause when web mode
  /// if user change one page's locale, other page need reflect change
  Future<void> setPreferredLocale(Locale? newLocale) async {
    if (newLocale == null) {
      _preferredLocale = null;
      await storage.remove(_kPreferredLocaleKey);
      return;
    }

    if (_preferredLocale == newLocale || !isLocaleValid(newLocale)) {
      return;
    }
    _preferredLocale = newLocale;
    await storage.setString(_kPreferredLocaleKey, newLocale.toString());
    notifyListeners();
  }

  /// of get I18nProvider from context
  static LanguageProvider of(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false);
  }
}
