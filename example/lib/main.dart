import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libcli/libcli.dart' as libcli;

import 'language_dropdown.dart';

// Security: Use environment variables for sensitive data like Sentry DSN
// Never hardcode API keys, tokens, or other sensitive information in source code
// Environment variables are loaded from .env file using flutter_dotenv package
main() async {
  await libcli.run(() => const ExampleApp());
}

class ExampleApp extends ConsumerWidget {
  const ExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(libcli.localeProvider);
    return MaterialApp(
      title: 'Libcli Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: CupertinoColors.activeBlue,
        ),
        brightness: Brightness.light,
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      locale: locale,
      localeResolutionCallback: libcli.localeResolutionCallback,
      localizationsDelegates: const [
        libcli.Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: libcli.Localization.supportedLocales,
    );
  }
}

class MyException2 implements Exception {
  final String message;

  MyException2(this.message);

  @override
  String toString() => 'MyException: $message';
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
            const LanguageDropdown(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                throw MyException2('This is a test exception');
              },
              child: const Text('Throw Exception'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  libcli.showConsole(context);
                },
                child: const Text('show console')),
          ])),
        ));
  }
}
