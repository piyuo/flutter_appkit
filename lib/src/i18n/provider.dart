import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart' as module;
import 'package:libcli/log.dart' as log;
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/src/i18n/i18n.dart';

class I18nProvider extends module.AsyncProvider {
  final String fileName;

  final String? package;

  Map _translation = {};

  I18nProvider({
    required this.fileName,
    this.package,
  });

  @protected
  String get description => '$runtimeType($fileName)';

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
        log.log('${log.COLOR_ALERT}missing $key in asset/i18n/${fileName}_${localeString}.json');
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
  return await asset.loadMap(assetName: 'i18n/${fileName}_${localeString}.json', package: package);
}
