// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../qrcode.dart';

main() => app.start(
      appName: 'barcode',
      routes: {
        '/': (context, state, data) => const QRCodeExample(),
      },
    );

class QRCodeExample extends StatelessWidget {
  const QRCodeExample({Key? key}) : super(key: key);

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
                child: _showScanner(context),
              ),
              testing.ExampleButton(
                label: 'generator',
                builder: () => _generator(),
              ),
              testing.ExampleButton(
                label: 'scanner',
                builder: () => _scanner(),
              ),
              testing.ExampleButton(
                label: 'scanner dialog',
                builder: () => _showScanner(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generator() {
    return const QRImage(
      data: 'http://cacake.piyuo.com/location=12348234234s',
    );
  }

  Widget _scanner() {
    return ChangeNotifierProvider<ScannerProvider>(
      create: (context) => ScannerProvider(
        onCodeScanned: (code) {
          Navigator.pop(context, code);
        },
      ),
      child: const Scanner(),
    );
  }

  Widget _showScanner(BuildContext context) {
    return OutlinedButton(
      child: const Text('show qr code scanner'),
      onPressed: () => showScanner(context),
    );
  }
}
