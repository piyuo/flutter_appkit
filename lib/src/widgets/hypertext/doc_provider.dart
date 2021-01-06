import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/log.dart';
import 'package:libcli/asset.dart' as asset;
import 'package:libcli/test.dart';

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
    if (testMode) {
      // don't load document in testMode, cause some big document cause pumpAndSettle timed out
      debugInfo('fake load asset:docs/${docName}_${currentLocaleID}.md');
    }
    md = await asset.loadString(
      assetName: 'docs/${docName}_${currentLocaleID}.md',
    );
  }
}
