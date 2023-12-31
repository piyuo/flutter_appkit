// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/testing/testing.dart' as testing;
import '../qrcode.dart';

main() => apollo.start(
      routes: {
        '/': (context, state, data) => const QRCodeExample(),
      },
    );

class QRCodeExample extends StatelessWidget {
  const QRCodeExample({super.key});

  @override
  Widget build(BuildContext context) {
    scanner(_) {
      return ChangeNotifierProvider<ScannerProvider>(
        create: (context) => ScannerProvider(
          onCodeScanned: (code) {
            Navigator.pop(context, code);
          },
        ),
        child: const Scanner(),
      );
    }

    tryShowScanner(_) {
      return OutlinedButton(
        child: const Text('show qr code scanner'),
        onPressed: () => showScanner(context),
      );
    }

    return testing.ExampleScaffold(
      builder: tryShowScanner,
      buttons: [
        testing.ExampleButton('scanner', builder: scanner),
        testing.ExampleButton('scanner dialog', builder: tryShowScanner),
      ],
    );
  }
}
