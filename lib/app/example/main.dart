import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
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

class AppExample extends StatelessWidget {
  const AppExample({
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
        testing.example(
          context,
          text: 'page route',
          child: _pushNewRoute(context),
        ),
      ],
    );
  }

  Widget _pushNewRoute(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
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
        ])),
      ),
    );
  }
}
