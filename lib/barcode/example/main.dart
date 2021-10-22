// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../src/qr_code.dart';
import '../src/barcode_scanner.dart';
import '../src/barcode_scanner_dialog.dart';

main() => app.start(
      appName: 'barcode example',
      routes: (_) => const BarcodeExample(),
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
              testing.example(
                context,
                text: 'QR code',
                child: _qrCode(),
              ),
              testing.example(
                context,
                text: 'barcode scanner',
                child: _barcodeScanner(),
              ),
              testing.example(
                context,
                text: 'show scanner dialog',
                child: _showBarcodeScanner(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrCode() {
    return const QRCode();
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
