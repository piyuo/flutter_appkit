// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/custom.dart' as custom;
import 'qr_code.dart';
import 'barcode_scanner.dart';
import 'barcode_scanner_dialog.dart';

class BarcodePlayground extends StatelessWidget {
  const BarcodePlayground({Key? key}) : super(key: key);

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
              custom.example(
                context,
                text: 'QR code',
                child: _qrCode(),
              ),
              custom.example(
                context,
                text: 'barcode scanner',
                child: _barcodeScanner(),
              ),
              custom.example(
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
