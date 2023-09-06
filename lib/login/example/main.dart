import 'package:libcli/base/base.dart' as base;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/testing/testing.dart' as testing;
import '../login.dart';

main() {
  final base.SessionProvider sessionProvider = base.SessionProvider(loader: (_) async => null);
  eventbus.listen<base.LoginEvent>(
    (event) async {
      debugPrint('login event');
    },
  );

  base.start(
    routesBuilder: () => {
      '/': (context, _, __) => const LayoutExample(),
    },
    dependencyBuilder: () => [
      ChangeNotifierProvider<base.SessionProvider>.value(
        value: sessionProvider,
      ),
    ],
  );
}

class LayoutExample extends StatelessWidget {
  const LayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginForm() {
      return Column(children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(40),
          child: LoginForm(onLoginSucceeded: () => debugPrint('login succeeded')),
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Example'),
      ),
      body: Column(children: [
        Expanded(child: loginForm()),
        Wrap(
          children: [
            testing.ExampleButton('login form', builder: loginForm, useScaffold: false),
          ],
        )
      ]),
    );
  }
}
