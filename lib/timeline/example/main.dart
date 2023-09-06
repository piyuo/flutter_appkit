// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/testing/testing.dart' as testing;
import '../timeline.dart';

main() => base.start(
      routesBuilder: () => {
        '/': (context, state, data) => const Example(),
      },
    );

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeline() {
      return Container(
          padding: const EdgeInsets.all(20),
          child: Timeline(
            completedIndex: 0,
            showLabel: true,
            steps: [
              TimelineStep(label: 'Create Order'),
              TimelineStep(label: 'Go to Store', icon: Icons.store),
              TimelineStep(
                label: 'Pick up',
                icon: Icons.fastfood,
              ),
            ],
          ));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              SizedBox(
                width: 590,
                child: timeline(),
              ),
              testing.ExampleButton('timeline', builder: timeline),
            ],
          ),
        ),
      ),
    );
  }
}
