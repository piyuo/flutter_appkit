import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/log.dart';
import 'package:libcli/asset.dart' as asset;

/// _testMode true should return success, false return error, otherwise behave normal
///
int _testMode = 0;

// testModeAlwaySuccess will let every function success
//
void testModeAlwaySuccess() {
  _testMode = 1;
}

// testModeAlwaySuccess will let every function fail
//
void testModeAlwayFail() {
  _testMode = -1;
}

// TestModeBackNormal stop test mode and back to normal
//
void testModeBackNormal() {
  _testMode = 0;
}

class DocProvider extends AsyncProvider {
  final String title;

  final String docName;

  String md = '';

  DocProvider({
    required this.docName,
    required this.title,
  });

  @override
  Future<void> load(BuildContext context) async {
    if (!kReleaseMode && _testMode != 0) {
      // don't load document in testMode, cause some big document cause pumpAndSettle() timed out
      debugInfo('fake load asset:docs/${docName}_${currentLocaleID}.md');
      return;
    }
    md = await asset.loadString(
      assetName: 'docs/${docName}_${currentLocaleID}.md',
    );
  }
}
