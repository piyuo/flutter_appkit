import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:intl/intl.dart';
import 'package:beamer/beamer.dart';
import '../app.dart';

class MyData {
  MyData({
    required this.name,
    required this.flag,
    required this.number,
  });
  final String name;
  final bool flag;
  final double number;
}

main() {
  start(appName: 'app example', routes: {
    '/': (context, state, data) => const BeamPage(
          key: ValueKey('home'),
          title: 'Home',
          child: AppExample(color: Colors.blue),
        ),
    '/other': (context, state, data) => BeamPage(
          key: const ValueKey('other'),
          title: 'other',
          child: AppExample(
            color: Colors.red,
            otherData: data != null ? data as MyData : null,
          ),
        ),
  });
}

class AppExample extends StatefulWidget {
  const AppExample({
    required this.color,
    this.otherData,
    Key? key,
  }) : super(key: key);

  final Color color;

  final MyData? otherData;

  @override
  State<StatefulWidget> createState() => AppExampleState();
}

class AppExampleState extends State<AppExample> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: _routing(context, widget.otherData),
        ),
        Container(
            color: Colors.black,
            child: Wrap(children: [
              testing.example(
                context,
                text: 'routing',
                useScaffold: false,
                child: _routing(context, widget.otherData),
              ),
              testing.example(
                context,
                text: 'localization',
                child: _localization(context),
              ),
              testing.example(
                context,
                text: 'test root context with dialog',
                child: _testRootContext(context),
              ),
              testing.example(
                context,
                text: 'scroll behavior',
                useScaffold: false,
                child: _scrollBehavior(context),
              ),
            ]))
      ],
    ));
  }

  Widget _routing(BuildContext context, MyData? otherData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        leading: beamerBack(context),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        if (otherData != null) Text('name=${otherData.name},flag=${otherData.flag},flag=${otherData.number}'),
        OutlinedButton(
            child: const Text('beam to other'),
            onPressed: () {
              context.beamToNamed('/other');
            }),
        OutlinedButton(
            child: const Text('beam to other with data'),
            onPressed: () {
              context.beamToNamed('/other',
                  data: MyData(
                    name: 'data',
                    flag: false,
                    number: 2.0,
                  ));
            }),
        const BeamerLink(
          child: Text('link:goto app'),
          appName: '/other',
          queryParameters: {'aa': 'bb'},
        ),
/*        OutlinedButton(
            child: const Text('goto app in new tab'),
            onPressed: () {
              gotoApp(context, '/other', newTab: true, args: {'app': 'newTab'});
            }),*/
        const BeamerLink(
          child: Text('link:goto app in new tab'),
          appName: '/other',
          newTab: true,
          queryParameters: {},
        ),
        OutlinedButton(
            child: const Text('root pop'),
            onPressed: () {
              rootPop(context);
            }),
        OutlinedButton(
            child: const Text('navigator push'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                    body: const Text('hello'),
                  ),
                ),
              );
            }),
        OutlinedButton(
            child: const Text('show snackbar'),
            onPressed: () {
              const snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
        OutlinedButton(
            child: const Text('show alert'),
            onPressed: () {
              dialog.alert(context, 'hello');
            }),
      ])),
    );
  }

  Widget _localization(BuildContext context) {
    String defaultLocale = Intl.defaultLocale ?? '';
    return Column(
      children: [
        Text(context.i18n.okButtonText),
        Text(Localizations.localeOf(context).toString()),
        Text('intl.defaultLocale=$defaultLocale'),
        Text('current locale=${i18n.localeName}, date=${i18n.formatDate(DateTime.now())}'),
        OutlinedButton(
            child: const Text('get locale to system default'),
            onPressed: () {
              setState(() {
                i18n.I18nProvider.of(context).overrideLocaleTemporary(null);
              });
            }),
        OutlinedButton(
            child: const Text('change locale to en'),
            onPressed: () {
              setState(() {
                i18n.I18nProvider.of(context).overrideLocaleTemporary(const Locale('en'));
              });
            }),
        OutlinedButton(
            child: const Text('change locale to zh'),
            onPressed: () {
              setState(() {
                i18n.I18nProvider.of(context).overrideLocaleTemporary(const Locale('zh'));
              });
            }),
        OutlinedButton(
            child: const Text('change locale to zh_TW'),
            onPressed: () {
              setState(() {
                i18n.I18nProvider.of(context).overrideLocaleTemporary(const Locale('zh', 'TW'));
              });
            }),
      ],
    );
  }

  Widget _testRootContext(BuildContext context) {
    return OutlinedButton(
      child: const Text('alert'),
      onPressed: () {
        dialog.alert(context, 'hello');
      },
    );
  }

  Widget _scrollBehavior(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Container(height: 500, color: Colors.red),
            Container(height: 500, color: Colors.blue),
            Container(height: 500, color: Colors.yellow),
            Container(height: 500, color: Colors.green),
          ]),
        )));
  }
}
