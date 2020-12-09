import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/module.dart';
import 'package:libcli/src/widgets/doc_provider.dart';

class DocPage extends ViewWidget<DocProvider> {
  final String docName;

  DocPage(this.docName) : super(i18nFilename: '');

  @protected
  createProvider(BuildContext context) => DocProvider(docName);

  @override
  Widget createWidget(BuildContext context) => DocWidget();
}

class DocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          //elevation: 0,
          backgroundColor: CupertinoColors.lightBackgroundGray,
          //iconTheme: IconThemeData(
          //  color: Colors.blue, //change your color here
          //),
        ),
        backgroundColor: CupertinoColors.lightBackgroundGray,
        child: SafeArea(
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
