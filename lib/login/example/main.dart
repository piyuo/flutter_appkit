import 'package:libcli/app/src/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/testing/testing.dart' as testing;
import '../login.dart';

main() {
  final SessionProvider sessionProvider = SessionProvider(loader: (_) async => null);
  eventbus.listen<app.LoginEvent>(
    (event) async {
      debugPrint('login event');
    },
  );

  app.start(
    appName: 'login example',
    routesBuilder: () => {
      '/': (context, _, __) => const LayoutExample(),
    },
    builder: () async => [
      ChangeNotifierProvider<app.SessionProvider>.value(
        value: sessionProvider,
      ),
    ],
  );
}

class LayoutExample extends StatelessWidget {
  const LayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Example'),
      ),
      body: Column(children: [
        Expanded(child: _loginForm(context)),
        Wrap(
          children: [
            testing.ExampleButton(label: 'login form', builder: () => _loginForm(context), useScaffold: false),
          ],
        )
      ]),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(40),
        child: LoginForm(onLoginSucceeded: () => debugPrint('login succeeded')),
      ),
    ]);
  }
}
