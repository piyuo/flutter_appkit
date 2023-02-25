import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'initialize_mixin.dart';

/// _kPreferredLocaleKey is preferred locale key in storage
const _kPreferredLocaleKey = 'locale';

/// LanguageProvider provide a way to change locale
class LanguageProvider with ChangeNotifier, InitializeMixin {
  LanguageProvider() {
    initFuture = () async {
      final locale = await loadPreferredLocale();
      if (locale != null) {
        i18n.locale = locale;
        notifyListeners();
      }
    };
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
    final locale = await loadPreferredLocale();
    if (locale == newLocale) {
      return;
    }

    if (newLocale != null) {
      await storage.setString(_kPreferredLocaleKey, newLocale.toString());
    } else {
      await storage.remove(_kPreferredLocaleKey);
    }
    notifyListeners();
  }

  /// of get I18nProvider from context
  static LanguageProvider of(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false);
  }
}
