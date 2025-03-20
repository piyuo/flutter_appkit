import 'package:flutter/cupertino.dart';
import 'package:locale_names/locale_names.dart';

/// A class that represents a language with its locale and name.
class Language {
  /// the locale of the language.
  final Locale locale;

  /// the name of the language in its native form.
  final String name;

  /// the name of the language in English.
  final String engName;

  /// Creates a [Language] instance.
  Language({required this.locale, required this.name, required this.engName});

  /// Returns the display name of the language in the format "engName - name".
  String get displayName => '$engName - $name';

  /// Returns a list of [Language] instances from the given list of supported locales.
  static List<Language> fromSupportedLocales(List<Locale> supportedLocales) {
    final enLocale = Locale('en');
    final result = supportedLocales.map((locale) {
      String name = locale.nativeDisplayLanguage;
      if (locale.nativeDisplayCountry.isNotEmpty) {
        name += ' (${locale.nativeDisplayCountry})';
      }

      String engName = locale.displayLanguageIn(enLocale);
      return Language(locale: locale, name: name, engName: engName);
    }).toList();
    result.sort((a, b) => a.engName.compareTo(b.engName));
    return result;
  }
}

/// A function that returns the locale resolution callback for the app.
Locale? localeResolutionCallback(locale, supportedLocales) {
  if (locale == null) {
    return const Locale('en'); // default to 'en'
  }

  // languageCode + countryCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
      return supportedLocale;
    }
  }

  // only languageCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return supportedLocale;
    }
  }

  // default 'en'
  return const Locale('en');
}
