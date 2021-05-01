import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart' as module;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/log.dart' as log;
import 'package:libcli/src/asset/main.dart' as asset;
import '../test.dart' as test;

class DocProvider extends module.AsyncProvider {
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
      log.debug('fake load asset:docs/${docName}_${i18n.currentLocaleID}.md');
      return;
    }
    md = await asset.loadString(
      assetName: 'docs/${docName}_${i18n.currentLocaleID}.md',
    );
  }
}
