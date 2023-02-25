import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'initialize_mixin.dart';

/// _kPreferredLocaleKey is preferred locale key in storage
const _kPreferredLocaleKey = 'locale';

/// LanguageProvider provide a way to change locale
class LanguageProvider with ChangeNotifier, InitializeMixin {
  LanguageProvider(this._initialLocales) {
    initFuture = () async {
      _preferredLocale = await loadPreferredLocale();
      if (_preferredLocale != null) {
        if (!isPreferredLocaleValid) {
          await setPreferredLocale(null);
          return;
        }
        notifyListeners();
      }
    };
  }

  /// _initialLocales is application initial supported locales
  final List<Locale> _initialLocales;

  /// _preferredLocale is user preferred locale
  Locale? _preferredLocale;

  /// preferredLocale return preferred locale
  Locale? get preferredLocale => _preferredLocale;

  /// supportedLocales return supported locales
  Iterable<Locale> get supportedLocales {
    if (_preferredLocale != null && _preferredLocale != _initialLocales.first) {
      // move preferred locale to first
      for (Locale locale in _initialLocales) {
        if (locale == _preferredLocale!) {
          _initialLocales.remove(locale);
          _initialLocales.insert(0, _preferredLocale!);
          break;
        }
      }
    }
    return _initialLocales;
  }

  /// isPreferredLocaleValid check preferred locale is valid
  bool get isPreferredLocaleValid {
    if (_preferredLocale == null) {
      return true;
    }
    for (Locale locale in _initialLocales) {
      if (locale == _preferredLocale!) {
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

    if (_preferredLocale == newLocale || !isPreferredLocaleValid) {
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
