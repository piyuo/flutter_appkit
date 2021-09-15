import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/log.dart' as log;
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/src/i18n/i18n.dart';

class I18nProvider extends delta.AsyncProvider {
  /// fileName is i18n language fileName
  final String fileName;

  /// package is i18n language package
  final String? package;

  /// fileName2 is second i18n language fileName, this usually a shared file between views in page
  final String? fileName2;

  /// package2 is second i18n language package, this usually a shared file between views in page
  final String? package2;

  Map _translation = {};

  /// i18nChangedSubscription is subscription for  i18n changed event
  eventbus.Subscription? i18nChangedSubscription;

  I18nProvider({
    required this.fileName,
    this.package,
    this.fileName2,
    this.package2,
  });

  @override
  String get description => '$runtimeType($fileName)';

  @override
  Future<void> load(BuildContext context) async {
    i18nChangedSubscription = eventbus.listen<I18nChangedEvent>((_, e) async {
      await _loadTranslation();
      notifyListeners();
    });
    await _loadTranslation();
  }

  Future<void> _loadTranslation() async {
    _translation = await getTranslation(
      fileName: fileName,
      package: package,
      fileName2: fileName2,
      package2: package2,
    );
  }

  @override
  void dispose() {
    if (i18nChangedSubscription != null) {
      i18nChangedSubscription!.cancel();
      i18nChangedSubscription = null;
    }
    super.dispose();
  }

  String translate(String key) {
    var value = _translation[key];
    if (value == null) {
      if (kReleaseMode) {
        return key;
      } else {
        log.log('[i18n] missing "$key" in asset/i18n/${fileName}_$localeString.json');
        return '!! $key not found';
      }
    }
    return value;
  }
}

/// getTranslation load translation from assets/i18n
///
Future<Map> getTranslation({
  required String fileName,
  String? package,
  String? fileName2,
  String? package2,
}) async {
  assert(fileName.isNotEmpty, 'need at least one language file');
  Map map = await asset.loadMap(assetName: 'i18n/${fileName}_$localeString.json', package: package);
  if (fileName2 != null && fileName2.isNotEmpty) {
    Map map2 = await asset.loadMap(assetName: 'i18n/${fileName2}_$localeString.json', package: package2);
    map.addAll(map2);
  }
  return map;
}
