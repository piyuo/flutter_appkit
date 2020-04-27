import 'dart:async';
import 'package:libcli/pattern.dart';
import 'package:libcli/src/i18n/i18n_state.dart';
import 'package:libcli/src/i18n/i18n.dart' as i18n;
import 'package:libcli/log.dart';
import 'package:flutter/material.dart';

class I18nProvider extends ReduxProvider<I18nState, dynamic> {
  final String _fileName;

  final String package;

  I18nProvider(this._fileName, {this.package})
      : super(null, I18nState(Map<String, dynamic>()));

  @override
  Future<void> load(BuildContext context) async {
    assert(_fileName != null, 'need page name');
    assert(i18n.locale != null, "need I18nDelegate to localizationsDelegates");
    state = await getTranslation(_fileName, package: package);
  }

  String translate(String key) {
    var value = state.translate(key);
    if (value == null) {
      alert(
          'i18n~missing $key in assets/i18n/${i18n.languageCode}/${i18n.countryCode}/${_fileName}.json');
      return '!!! $key not found';
    }
    return value;
  }
}
