import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/assets/assets.dart' as asset;
import 'show_more.dart';

/// I18nLocalization add localization function to string
///
extension HypertextDialog on delta.Hypertext {
  void moreText(
    String text, {
    required String content,
    Size size = const Size(240, 180),
  }) {
    return action(
      text,
      onTap: (BuildContext context, TapUpDetails details) {
        showMoreText(
          context,
          text: content,
          targetRect: Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 15),
          size: size,
        );
      },
    );
  }

  void moreDoc(
    String text, {
    required String docName,
  }) {
    return action(
      text,
      onTap: (BuildContext context, _) {
        Navigator.of(context).push(
          delta.safeTestMaterialRoute(
            _DocPage(docName: docName, title: text),
          ),
        );
      },
    );
  }
}

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
            builder: (context, provider, child) => Scaffold(
                appBar: AppBar(
                  title: Text(provider.title),
                ),
                body: SafeArea(
                  right: false,
                  bottom: false,
                  child: Stack(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 62),
                      child: Consumer<_DocProvider>(builder: (context, provider, _) => Markdown(data: provider.md)),
                    ),
                    Positioned(
                      left: 30,
                      right: 30,
                      bottom: 8,
                      child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            child: Text(context.i18n.backButtonText),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(40, 20, 40, 20)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                )),
                            onPressed: () => Navigator.pop(context),
                          )),
                    )
                  ]),
                ))));
  }
}

class _DocProvider extends delta.AsyncProvider {
  final String title;

  final String docName;

  String md = '';

  _DocProvider({
    required this.docName,
    required this.title,
  });

  @override
  Future<void> load(BuildContext context) async {
    md = await asset.loadString(
      assetName: 'docs/${docName}_${i18n.localeName}.md',
    );
  }
}
