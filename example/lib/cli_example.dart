// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/cli/cli.dart' as cli;
import 'package:libcli/testing/testing.dart' as testing;

main() => cli.run(() => const AudioExample());

class AudioExample extends StatelessWidget {
  const AudioExample({super.key});

  @override
  Widget build(BuildContext context) {
    exceptionHandling(_) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Throw Exception'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Throw Exception with Message'),
          ),
        ],
      );
    }

    return testing.ExampleScaffold(
      builder: exceptionHandling,
      buttons: [
        testing.ExampleButton('Exception Handling', builder: exceptionHandling),
      ],
    );
  }
}
