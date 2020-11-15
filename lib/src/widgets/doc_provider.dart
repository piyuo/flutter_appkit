import 'package:flutter/material.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/asset.dart' as asset;

class DocProvider extends AsyncProvider {
  final String docName;

  String md = '';

  DocProvider(
    final this.docName,
  );

  @override
  Future<void> load(BuildContext context) async {
    md = await asset.loadString(
      assetName: 'docs/${docName}_${localeID}.md',
    );
  }
}
