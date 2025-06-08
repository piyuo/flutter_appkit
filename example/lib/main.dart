import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:libcli/cli/cli.dart' as cli;
import 'package:libcli/l10n/localization.dart';

main() => cli.run(() => const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libcli Example',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      locale: Intl.defaultLocale == null ? const Locale('en', 'US') : Locale(Intl.defaultLocale!),
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localization.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vision example'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
            ElevatedButton(
              onPressed: () async {
                throw Exception('This is an exception');
              },
              child: const Text('Throw Exception'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LiveExample(path: 'https://cdn-004.whatsupcams.com/hls/hr_pula06.m3u8')),
                  );*/
                },
                child: const Text('live stream')),
          ])),
        ));
  }
}
