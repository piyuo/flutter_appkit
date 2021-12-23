// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../payment.dart';

main() => app.start(
      appName: 'payment',
      routes: {
        '/': (context, state, data) => const BarcodeExample(),
      },
    );

class BarcodeExample extends StatelessWidget {
  const BarcodeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: _pay(),
              ),
              testing.example(
                context,
                text: 'pay',
                child: _pay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pay() {
    return const Payment();
  }
}
