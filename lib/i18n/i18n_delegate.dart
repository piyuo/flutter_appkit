import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

class I18nDelegate extends LocalizationsDelegate {
  @override
  bool isSupported(Locale locale) => i18n.isSupportedLocale(locale);

  @override
  Future load(Locale l) async {
    i18n.localeID = i18n.localeToId(l);
    return null;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
