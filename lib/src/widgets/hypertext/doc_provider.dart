import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/asset/asset.dart' as asset;
import 'package:libcli/src/widgets/test.dart' as test;

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
    if (!kReleaseMode && test.isMock()) {
      // don't load document in testMode, cause some big document cause pumpAndSettle() timed out
      debugInfo('fake load asset:docs/${docName}_${currentLocaleID}.md');
      return;
    }
    md = await asset.loadString(
      assetName: 'docs/${docName}_${currentLocaleID}.md',
    );
  }
}
