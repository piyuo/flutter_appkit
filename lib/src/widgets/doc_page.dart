import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/module.dart';
import 'package:libcli/src/widgets/doc_provider.dart';

class DocPage extends ViewWidget<DocProvider> {
  final String docName;

  DocPage(this.docName) : super('');

  @protected
  createProvider(BuildContext context) => DocProvider(docName);

  @override
  Widget createWidget(BuildContext context) => DocWidget();
}

class DocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[50],
          iconTheme: IconThemeData(
            color: Colors.blue, //change your color here
          ),
        ),
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          right: false,
          bottom: false,
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: Consumer<DocProvider>(builder: (context, provider, _) => Markdown(data: provider.md)),
            ),
            Positioned(
              left: 30,
              right: 30,
              bottom: 8,
              child: CupertinoButton(
                  //color: Theme.of(context).accentColor,
                  child: Text('back'.i18n_),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ]),
        ));
  }
}
