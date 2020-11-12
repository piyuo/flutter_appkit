import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

const _here = 'assets';

/// loadString return string if asset exist, return empty string if not found.
///
/// using context to load asset from context
///
///  using package to load asset from packages
///
///     String asset = await assets.loadString(assetName:'i18n/en/US/global.json');
///
Future<String> Function({required String assetName, BuildContext? context, String? package}) loadString = _loadString;

Future<String> _loadString({required String assetName, BuildContext? context, String? package}) async {
  String path = package != null ? 'packages/$package/assets/$assetName' : 'assets/$assetName';
  debugPrint('$_here~load asset $path');

  //File myAsset = File(path);
  //String text = myAsset.readAsStringSync();
  try {
    if (context != null) {
      var bundle = DefaultAssetBundle.of(context);
      return await bundle.loadString(path);
    }
    return await rootBundle.loadString(path);
  } catch (e, s) {
    error(_here, e, s);
  }
  return '';
}

/// loadJson return json if asset exist, return empty json if not found.
///
/// using context to load asset from context
///
///  using package to load asset from packages
///
///     String asset = await assets.loadString(assetName:'i18n/en/US/global.json');
///
Future<String> loadJson({required String assetName, BuildContext? context, String? package}) async {
  String json = await loadString(assetName: assetName, context: context, package: package);
  if (json.length > 0) {
    return json;
  }
  return '{}';
}

/// loadMap return map if asset exist, return empty json if not found.
///
/// using context to load asset from context
///
///  using package to load asset from packages
///
///     Map map = await assets.loadMap(assetName:'i18n/en/US/global.json');
///
Future<Map> loadMap({required String assetName, BuildContext? context, String? package}) async {
  String text = await loadJson(assetName: assetName, context: context, package: package);
  return json.decode(text);
}

/// mockAssets Initializes the value for testing
///
///     Future<String> _mockLoadAssets(String assetName,
///       {BuildContext context, String package}) async {
///       return 'hi';
///     }
///     assets.mock((_mockLoadAssets));
///
@visibleForTesting
mockAssets(Future<String> Function({required String assetName, BuildContext? context, String? package}) func) {
  loadString = func;
}

/// mockAssetsByString Initializes the value for testing
///
///     Future<String> _mockLoadAssets(String assetName,
///       {BuildContext context, String package}) async {
///       return 'hi';
///     }
///     assets.mock((_mockLoadAssets));
///
@visibleForTesting
mockAssetsByString(String text) {
  Future<String> _mockLoadAssets({required String assetName, BuildContext? context, String? package}) async {
    return text;
  }

  mockAssets((_mockLoadAssets));
}

/// mockAssetsStop stop mock
///
///     assets.mockStop();
///
@visibleForTesting
mockAssetsStop() {
  loadString = _loadString;
}
