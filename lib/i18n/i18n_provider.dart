import 'dart:async';
import 'package:libcli/redux/redux_provider.dart';
import 'package:libcli/i18n/i18n_state.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/log/log.dart';

class I18nProvider extends ReduxProvider<I18nState, dynamic> {
  final String _pageName;

  I18nProvider(this._pageName) : super(null, I18nState(Map<String, dynamic>()));

  @override
  Future<void> load() async {
    assert(_pageName.length > 0, 'need page name');
    assert(i18n.localeID.length > 0,
        "need I18nDelegate to localizationsDelegates");

    var key = '${_pageName}_${i18n.localeID}';
    state = await readState(key);
  }

  String translate(String key) {
    var value = state.translate(key);
    if (value == null) {
      'i18n|missing $key in ${_pageName}_${i18n.localeID}'.alert;
      return '!!! $key not found';
    }
    return value;
  }
}
