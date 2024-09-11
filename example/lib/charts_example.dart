// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/charts/charts.dart';
import 'package:libcli/testing/testing.dart' as testing;

main() => apollo.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routes: {
        '/': (context, state, data) => const ChartsExample(),
      },
    );

class ChartsExample extends StatelessWidget {
  const ChartsExample({super.key});

  @override
  Widget build(BuildContext context) {
    indicator(_) {
      return const Indicator(title: '翻桌率', text: '3.2');
    }

    timeChart(_) {
      return const TimeChart(title: 'Sales', subtitle: '\$32,437');
    }

    return testing.ExampleScaffold(
      builder: timeChart,
      buttons: [
        testing.ExampleButton('time chart', builder: timeChart),
        testing.ExampleButton('indicator', builder: indicator),
      ],
    );
  }
}
