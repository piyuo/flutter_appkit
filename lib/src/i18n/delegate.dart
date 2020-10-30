import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/src/i18n/i18n.dart' as i18n;
import 'package:libcli/src/i18n/global.dart';

class I18nDelegate extends LocalizationsDelegate<Locale> {
  @override
  bool isSupported(Locale locale) => i18n.isSupportedLocale(locale);

  @override
  Future<Locale> load(Locale l) async {
    i18n.locale = l;
    reloadGlobalTranslation(l.languageCode, l.countryCode);
    return l;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
