// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/net/net.dart' as net;
import '../signin.dart';

main() => apollo.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routes: {
        '/': (context, state, data) => const Example(),
        '/signin': (context, state, data) => const SigninScreen(),
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

    authService.mockSender = (net.Object action, {net.Builder? builder}) async {
      if (action is auth.VerifyEmailAction) {
        return auth.SendPinResponse(result: auth.SendPinResponse_Result.RESULT_OK);
      }
      if (action is auth.LoginPinAction) {
        return auth.LoginPinResponse(
          result: auth.LoginPinResponse_Result.RESULT_OK,
          access: auth.Access(
            state: auth.Access_State.STATE_OK,
            region: auth.Access_Region.REGION_UNSPECIFIED,
            accessToken: 'fakeAccess',
            accessExpire: DateTime.now().add(const Duration(seconds: 300)).timestamp,
            refreshToken: 'fakeRefresh',
            refreshExpire: DateTime.now().add(const Duration(days: 300)).timestamp,
          ),
        );
      }
      if (action is auth.ResendPinAction) {
        return auth.SendPinResponse(result: auth.SendPinResponse_Result.RESULT_OK);
      }
      throw Exception('$action is not supported');
    };
  }

  @override
  Widget build(BuildContext context) {
    signinScreen() {
      return const SigninScreen(loader: _load, redirectTo: '/success');
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
