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
    appName: 'login example',
    routesBuilder: () => {
      '/': (context, _, __) => const LayoutExample(),
    },
    dependencyBuilder: () async => [
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
