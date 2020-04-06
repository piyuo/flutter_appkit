import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

const _here = 'assets';

typedef Future<String> LoadString(
  String assetName, {
  BuildContext context,
  String package,
});

LoadString loadString = _loadString;

/// loadString return string if asset exist, return empty string if not found.
///
/// using context to load asset from context
///
///  using package to load asset from packages
///
///     String asset = await assets.loadString('i18n/libcli_en_US.json');
///
Future<String> _loadString(String assetName,
    {BuildContext context, String package}) async {
  debugPrint('$_here|load asset $assetName');
  String path =
      package != null ? 'packages/$package/$assetName' : 'assets/$assetName';
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
///     String asset = await assets.loadString('i18n/libcli_en_US.json');
///
Future<String> loadJson(String assetName,
    {BuildContext context, String package}) async {
  String json = await loadString(assetName, context: context, package: package);
  if (json.length > 0) {
    return json;
  }
  return '{}';
}

/// mock Initializes the value for testing
///
///     Future<String> _mockLoadAssets(String assetName,
///       {BuildContext context, String package}) async {
///       return 'hi';
///     }
///     assets.mock((_mockLoadAssets));
///
@visibleForTesting
mock(LoadString func) {
  loadString = func;
}

/// mock Initializes the value for testing
///
///     Future<String> _mockLoadAssets(String assetName,
///       {BuildContext context, String package}) async {
///       return 'hi';
///     }
///     assets.mock((_mockLoadAssets));
///
@visibleForTesting
mockString(String text) {
  Future<String> _mockLoadAssets(String assetName,
      {BuildContext context, String package}) async {
    return text;
  }

  mock((_mockLoadAssets));
}

/// mockStop stop mock
///
///     assets.mockStop();
///
@visibleForTesting
mockStop() {
  loadString = _loadString;
}
