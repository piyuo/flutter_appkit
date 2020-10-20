import 'dart:async';
import 'package:libcli/redux.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/log.dart';
import 'package:flutter/material.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:flutter/foundation.dart';

class I18nProvider extends AsyncProvider {
  final String _fileName;

  final String package;

  Map _translation = {};

  I18nProvider(this._fileName, {this.package});

  @override
  Future<void> load(BuildContext context) async {
    assert(_fileName != null, 'need page name');
    assert(currentLocale != null, "please add I18nDelegate to app's localizationsDelegates");
    _translation = await getTranslation(_fileName, package: package);
  }

  String translate(String key) {
    var value = _translation[key];
    if (value == null) {
      if (kReleaseMode) {
        return key;
      } else {
        alert('i18n~missing $key in assets/i18n/${_fileName}_${localeID}.json');
        return '!!! $key not found';
      }
    }
    return value;
  }
}

/// getTranslation load translation from assets/i18n
///
Future<Map> getTranslation(String filename, {String package}) async {
  var localization = {};
  if (filename != null && filename.isNotEmpty) {
    localization = await asset.loadMap('i18n/${filename}_${localeID}.json', package: package);
  }
  return localization;
}
