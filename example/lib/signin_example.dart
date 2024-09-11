// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/signin/signin.dart';
import 'package:libcli/testing/testing.dart' as testing;

main() => apollo.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routes: {
        '/': (context, state, data) => const Example(),
        '/success': (context, state, data) => const Text('Success'),
      },
    );

class Example extends StatelessWidget {
  const Example({super.key});

  static Future<void> _load(BuildContext context) async {
    final authService = auth.AuthService.of(context);
    final languageProvider = apollo.LanguageProvider.of(context);
    final sessionProvider = apollo.SessionProvider.of(context);
    await languageProvider.init();
    await sessionProvider.init();
    testing.mockAuthResponse(authService);
  }

  @override
  Widget build(BuildContext context) {
    signinScreen(_) {
      return const SigninScreen(loader: _load, redirectTo: '/success/');
    }

    return testing.ExampleScaffold(
      builder: signinScreen,
      buttons: [
        OutlinedButton(
          onPressed: () {
            //Beamer.of(context).beamToNamed('/signin');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SigninScreen(),
                ));
          },
          child: const Text('redirect to SigninScreen'),
        ),
        testing.ExampleButton('SigninScreen', builder: signinScreen),
      ],
    );
  }
}
