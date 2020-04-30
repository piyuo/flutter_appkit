import 'package:flutter/material.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/asset.dart' as asset;

class DocProvider extends AsyncProvider {
  final String docName;

  String md;

  DocProvider(this.docName);

  @override
  Future<void> load(BuildContext context) async {
    md = await asset.loadString(
      'docs/${docName}_${languageCode}_${countryCode}.md',
    );
  }
}
