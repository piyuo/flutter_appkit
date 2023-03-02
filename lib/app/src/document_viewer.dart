import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/assets/assets.dart' as asset;
import 'loading_screen.dart';

/// DocumentViewer show document from asset
class DocumentViewer extends StatelessWidget {
  const DocumentViewer({
    required this.docName,
    this.title = '',
    Key? key,
  }) : super(key: key);

  final String title;

  final String docName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_DocumentViewerProvider>(
        create: (context) => _DocumentViewerProvider(
              docName: docName,
              title: title,
            ),
        child: Consumer<_DocumentViewerProvider>(
            builder: (context, docProvider, child) => LoadingScreen(
                  future: () async => await docProvider.load(),
                  builder: () => Scaffold(
                      appBar: AppBar(
                        title: Text(docProvider.title),
                      ),
                      body: SafeArea(
                        right: false,
                        bottom: true,
                        child: Padding(padding: const EdgeInsets.all(10), child: Markdown(data: docProvider.md)),
                      )),
                )));
  }
}

/// _DocumentViewerProvider load doc from asset
class _DocumentViewerProvider with ChangeNotifier {
  _DocumentViewerProvider({
    required this.docName,
    required this.title,
  });

  /// title is doc title
  final String title;

  /// docName is doc name
  final String docName;

  /// md is markdown content
  String md = '';

  Future<void> load() async {
    md = await asset.loadString(
      assetName: 'docs/${docName}_${i18n.localeKey}.md',
    );
    notifyListeners();
  }
}
