import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/module.dart' as module;
import 'hypertext-doc-provider.dart';

class DocPage extends module.ViewWidget<DocProvider> {
  final String title;

  final String docName;

  DocPage({
    required this.docName,
    this.title = '',
  }) : super(i18nFilename: '');

  @protected
  createProvider(BuildContext context) => DocProvider(
        docName: docName,
        title: title,
      );

  @override
  Widget createWidget(BuildContext context) => DocWidget();
}

class DocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DocProvider>(
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
                  child: Consumer<DocProvider>(builder: (context, provider, _) => Markdown(data: provider.md)),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 8,
                  child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: Text('back'.i18n_),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.cyan[700]),
                            padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(40, 20, 40, 20)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            )),
                        onPressed: () => Navigator.pop(context),
                      )),
                )
              ]),
            )));
  }
}
