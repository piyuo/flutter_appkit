import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart' as module;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/src/asset/asset.dart' as asset;

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
    md = await asset.loadString(
      assetName: 'docs/${docName}_${i18n.localeString}.md',
    );
  }
}
