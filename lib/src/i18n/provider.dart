import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/log.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:flutter/foundation.dart';

class I18nProvider extends AsyncProvider {
  final String fileName;

  final String? package;

  Map _translation = {};

  I18nProvider({
    required this.fileName,
    this.package,
  });

  @override
  Future<void> load(BuildContext context) async {
    _translation = await getTranslation(fileName: fileName, package: package);
  }

  String translate(String key) {
    var value = _translation[key];
    if (value == null) {
      if (kReleaseMode) {
        return key;
      } else {
        log('${COLOR_ALERT}missing $key in assets/i18n/${fileName}_${currentLocaleID}.json');
        return '!!! $key not found';
      }
    }
    return value;
  }
}

/// getTranslation load translation from assets/i18n
///
Future<Map> getTranslation({required String fileName, String? package}) async {
  if (fileName.isEmpty) {
    return {};
  }
  return await asset.loadMap(assetName: 'i18n/${fileName}_${currentLocaleID}.json', package: package);
}
