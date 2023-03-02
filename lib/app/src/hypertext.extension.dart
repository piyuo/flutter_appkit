import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/assets/assets.dart' as asset;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'loading_screen.dart';

/// HypertextDialogExtension add text popup and doc route to Hypertext
extension HypertextDialogExtension on delta.Hypertext {
  /// moreText show text link on text and show content when tap
  void moreText(
    String text, {
    required String content,
    Size size = const Size(240, 180),
  }) {
    return action(
      text,
      onTap: (BuildContext context, TapUpDetails details) {
        dialog.showMoreText(
          context,
          text: content,
          targetRect: Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 15),
          size: size,
        );
      },
    );
  }

  /// moreText show doc link on text and push doc page when tap
  void moreDoc(
    String text, {
    required String docName,
  }) {
    return action(
      text,
      onTap: (BuildContext context, _) => delta.pushRoute(context, _DocPage(docName: docName, title: text)),
    );
  }
}

/// _DocPage show doc page
class _DocPage extends StatelessWidget {
  const _DocPage({
    required this.docName,
    this.title = '',
    Key? key,
  }) : super(key: key);

  final String title;

  final String docName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_DocProvider>(
        create: (context) => _DocProvider(
              docName: docName,
              title: title,
            ),
        child: Consumer<_DocProvider>(
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

/// _DocProvider load doc from asset
class _DocProvider with ChangeNotifier {
  _DocProvider({
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
