import 'dart:async';
import 'package:libcli/pattern.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/log.dart';
import 'package:flutter/material.dart';
import 'package:libcli/asset.dart' as asset;

class I18nProvider extends ReduxProvider {
  final String _fileName;

  final String package;

  I18nProvider(this._fileName, {this.package}) : super(null, {});

  @override
  Future<void> load(BuildContext context) async {
    assert(_fileName != null, 'need page name');
    assert(locale != null,
        "please add I18nDelegate to app's localizationsDelegates");
    state = await getTranslation(_fileName, package: package);
  }

  String translate(String key) {
    var value = state[key];
    if (value == null) {
      alert(
          'i18n~missing $key in assets/i18n/${_fileName}_${languageCode}_${countryCode}.json');
      return '!!! $key not found';
    }
    return value;
  }
}

/// getTranslation load translation from assets/i18n
///
Future<Map> getTranslation(String filename, {String package}) async {
  var localization = {};
  if (filename != null && filename.isNotEmpty) {
    localization = await asset.loadMap(
        'i18n/${filename}_${languageCode}_${countryCode}.json',
        package: package);
  }
  return localization;
}
