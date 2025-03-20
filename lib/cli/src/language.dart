import 'package:flutter/cupertino.dart';
import 'package:locale_names/locale_names.dart';

/// A class that represents a language with its locale and name.
class Language {
  final Locale locale;
  final String name;

  Language(this.locale, this.name);

  static List<Language> fromSupportedLocales(List<Locale> supportedLocales) {
    return supportedLocales.map((locale) {
      String name = locale.nativeDisplayLanguage;
      if (locale.nativeDisplayCountry.isNotEmpty) {
        name += ' (${locale.nativeDisplayCountry})';
      }
      return Language(locale, name);
    }).toList();
  }
}
