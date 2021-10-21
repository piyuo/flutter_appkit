// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import '../src/env.dart';

main() {
  start(
    appName: 'envExample',
    routes: (String name) {
      switch (name) {
        case '/':
          return delta.NoAnimRouteBuilder(const EnvExample(color: Colors.blue));
        case '/new_route':
          return delta.NoAnimRouteBuilder(const EnvExample(color: Colors.red));
      }
    },
  );
}

class EnvExample extends StatelessWidget {
  const EnvExample({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: _pushNewRoute(context),
        ),
      ],
    );
  }

  Widget _pushNewRoute(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: const [
          Text('started!!!'),
        ])),
      ),
    );
  }
}
