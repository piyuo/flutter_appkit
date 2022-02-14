// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../src/qr_code.dart';
import '../src/barcode_scanner.dart';
import '../src/barcode_scanner_dialog.dart';

main() => app.start(
      appName: 'barcode',
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
                child: _showBarcodeScanner(context),
              ),
              testing.ExampleButton(
                label: 'QR code',
                builder: () => _qrCode(),
              ),
              testing.ExampleButton(
                label: 'barcode scanner',
                builder: () => _barcodeScanner(),
              ),
              testing.ExampleButton(
                label: 'show scanner dialog',
                builder: () => _showBarcodeScanner(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrCode() {
    return const QRCode(
      data: 'http://cacake.piyuo.com/location=12348234234s',
    );
  }

  Widget _barcodeScanner() {
    return const BarcodeScanner();
  }

  Widget _showBarcodeScanner(BuildContext context) {
    return OutlinedButton(
      child: const Text('show qr code scanner'),
      onPressed: () => showQRcodeScanner(context),
    );
  }
}
