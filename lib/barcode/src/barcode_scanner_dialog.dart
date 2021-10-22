import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'barcode_scanner.dart';
import 'l10n.dart';

/// showQRcodeScanner return scanned QR code or null if not scanned
Future<String?> showQRcodeScanner(BuildContext context) async {
  if (await delta.checkCameraPermission(context)) {
    return Navigator.push<String?>(
        context,
        MaterialPageRoute(
          builder: (_) => const BarcodeScannerDialog(),
        ));
  }
}

class BarcodeScannerDialog extends StatelessWidget {
  const BarcodeScannerDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.grey[400]!,
        ),
        centerTitle: true,
        title: Text('scanQR'.l10n,
            style: TextStyle(
              color: Colors.grey[400],
            )),
        elevation: 0,
      ),
      body: BarcodeScanner(
        onQRCodeScanned: (BuildContext context, String code) {
          Navigator.pop(context, code);
        },
      ),
    );
  }
}
