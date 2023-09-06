// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import '../charts.dart';

main() => base.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routesBuilder: () => {
        '/': (context, state, data) => const ChartsExample(),
      },
    );

class ChartsExample extends StatelessWidget {
  const ChartsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    indicator() {
      return const Indicator(title: '翻桌率', text: '3.2');
    }

    timeChart() {
      return const TimeChart(title: 'Sales', subtitle: '\$32,437');
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Expanded(
                child: timeChart(),
              ),
              testing.ExampleButton('time chart', builder: timeChart),
              testing.ExampleButton('indicator', builder: indicator),
            ],
          ),
        ),
      ),
    );
  }
}
