import 'package:flutter/widgets.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/asset.dart' as asset;

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
    md = await asset.loadString(
      assetName: 'docs/${docName}_${currentLocaleID}.md',
    );
  }
}
