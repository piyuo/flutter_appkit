// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import '../charts.dart';

main() => app.start(
      appName: 'charts example',
      routesBuilder: () => {
        '/': (context, state, data) => const ChartsExample(),
      },
    );

class ChartsExample extends StatelessWidget {
  const ChartsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Expanded(
                child: _indicator(),
              ),
              testing.ExampleButton(
                label: 'line chart',
                builder: () => _timeChart(),
              ),
              testing.ExampleButton(
                label: 'indicator',
                builder: () => _indicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicator() {
    return const Indicator(title: '翻桌率', text: '3.2');
  }

  Widget _timeChart() {
    return const TimeChart(title: 'Sales', subtitle: '\$32,437');
  }
}
