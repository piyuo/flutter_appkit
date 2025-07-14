import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appkit/flutter_appkit.dart' as appkit;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_dropdown.dart';

// Security: Use environment variables for sensitive data like Sentry DSN
// Never hardcode API keys, tokens, or other sensitive information in source code
// Environment variables are loaded from .env file using flutter_dotenv package
main() async {
  await appkit.appRun(() => const ExampleApp());
}

class ExampleApp extends ConsumerWidget {
  const ExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appkit.localeProvider);
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
      home: const appkit.GlobalContext(child: MyHomePage(title: 'Flutter Demo Home Page')),
      locale: locale,
      localeResolutionCallback: appkit.localeResolutionCallback,
      localizationsDelegates: const [
        appkit.Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: appkit.Localization.supportedLocales,
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
          title: const Text('LibCLI Error Handling Demo'),
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
              child: const Text('Throw Exception Once'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // First call - will show dialog
                throw MyException2('Repeated error message');
              },
              child: const Text('Throw Error First Time'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Second call with same error - will be suppressed
                throw MyException2('Repeated error message');
              },
              child: const Text('Throw Same Error Again (Suppressed)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // This demonstrates different error types are not suppressed
                throw ArgumentError('Different error type');
              },
              child: const Text('Throw Different Error Type'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // This demonstrates rapid multiple different errors
                await Future.delayed(const Duration(milliseconds: 50));
                throw StateError('State error 1');
              },
              child: const Text('Throw State Error'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                appkit.logDebug('Debug log example');
                appkit.logInfo('Info log example');
                appkit.logWarning('Warning log example');
                appkit.logCritical('Critical log example');
                appkit.logError('Error log example');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log functions called! Check console.')),
                );
              },
              child: const Text('Show Log Function Usage'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  appkit.logShowConsole(context);
                },
                child: const Text('Show Console')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Show a dialog with the value of a sample environment variable
                final sentryDsn = appkit.envGet('SENTRY_DSN', defaultValue: 'Not set');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('envGet Example'),
                    content: Text('SENTRY_DSN: $sentryDsn'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show envGet("SENTRY_DSN")'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                // Demonstrate preferences usage
                const key = 'demo_key';
                await appkit.prefSetString(key, 'Hello Preferences');
                final value = await appkit.prefGetString(key);
                await appkit.prefSetInt('demo_int', 42);
                final intValue = await appkit.prefGetInt('demo_int');
                await appkit.prefSetBool('demo_bool', true);
                final boolValue = await appkit.prefGetBool('demo_bool');
                await appkit.prefRemoveKey('demo_key');
                final removedValue = await appkit.prefGetString(key);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'String: $value\nInt: $intValue\nBool: $boolValue\nRemoved: $removedValue',
                    ),
                  ),
                );
              },
              child: const Text('Show Preferences Function Usage'),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Error Handling Demo:\n\n'
                '🔄 "Throw Error First Time" - Shows error dialog\n'
                '🚫 "Throw Same Error Again" - Suppressed (same error within 1 minute)\n'
                '✅ "Throw Different Error Type" - Always shown (different error type)\n'
                '🛡️ Multiple dialogs cannot appear simultaneously\n\n'
                'This prevents error dialog spam while ensuring different errors are visible.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ])),
        ));
  }
}
