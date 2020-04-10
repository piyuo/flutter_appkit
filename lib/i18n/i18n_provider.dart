import 'dart:async';
import 'package:libcli/pattern/redux_provider.dart';
import 'package:libcli/i18n/i18n_state.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/log/log.dart';
import 'package:flutter/material.dart';

class I18nProvider extends ReduxProvider<I18nState, dynamic> {
  final String _pageName;

  I18nProvider(this._pageName) : super(null, I18nState(Map<String, dynamic>()));

  @override
  Future<void> load(BuildContext context) async {
    assert(_pageName.length > 0, 'need page name');
    assert(i18n.locale != null, "need I18nDelegate to localizationsDelegates");
    state = await readState(_pageName, i18n.languageCode, i18n.countryCode);
  }

  String translate(String key) {
    var value = state.translate(key);
    if (value == null) {
      alert(
          'i18n~missing $key in assets/i18n/${i18n.languageCode}/${i18n.countryCode}/${_pageName}.json');
      return '!!! $key not found';
    }
    return value;
  }
}
