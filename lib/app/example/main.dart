import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:intl/intl.dart';
import '../src/app.dart';
import '../src/page_route.dart' as page_route;
import '../src/back_button.dart';

main() {
  start(
    appName: 'app example',
    routes: (String name) {
      switch (name) {
        case '/':
          return const AppExample(color: Colors.blue);
        case '/new_route':
          return const AppExample(color: Colors.red);
      }
    },
  );
}

class AppExample extends StatefulWidget {
  const AppExample({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  @override
  State<StatefulWidget> createState() => AppExampleState();
}

class AppExampleState extends State<AppExample> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: 300,
          child: _pageRoute(context),
        ),
        testing.example(
          context,
          text: 'page route',
          useScaffold: false,
          child: _pageRoute(context),
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
      ],
    ));
  }

  Widget _pageRoute(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        leading: backButton(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          if (page_route.args['arg1'] != null) Text('current arg1=${page_route.args['arg1']}'),
          OutlinedButton(
              child: const Text('new route'),
              onPressed: () {
                page_route.push(context, '/new_route', args: {'arg1': 'new_route'});
              }),
          OutlinedButton(
              child: const Text('new route in other tab'),
              onPressed: () {
                page_route.push(context, '/new_route', openNewTab: true, args: {'arg1': 'new_route_other_tab'});
              }),
          OutlinedButton(
              child: const Text('pop'),
              onPressed: () {
                page_route.pop(context);
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
      ),
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
