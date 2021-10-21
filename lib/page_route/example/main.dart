// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/custom.dart' as custom;
import 'package:libcli/delta.dart' as delta;
import '../src/page_route.dart' as page_route;
import '../src/back_button.dart';

main() {
  page_route.init();
  runApp(MaterialApp(
    onGenerateRoute: (RouteSettings settings) {
      switch (page_route.listen(settings)) {
        case '': // for web with url route, return null to skip default route
          return null;
        case '/':
          return delta.NoAnimRouteBuilder(const PageRoutePlayground(color: Colors.blue));
        case '/new_route':
          return delta.NoAnimRouteBuilder(const PageRoutePlayground(color: Colors.red));

        default:
          return MaterialPageRoute(
              builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ));
      }
    },
  ));
}

class PageRoutePlayground extends StatelessWidget {
  const PageRoutePlayground({
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
        custom.example(
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
