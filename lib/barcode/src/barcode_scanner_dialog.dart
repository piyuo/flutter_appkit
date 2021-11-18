import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/permission/permission.dart' as permission;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'barcode_scanner.dart';

/// showQRcodeScanner return scanned QR code or null if not scanned
Future<String?> showQRcodeScanner(BuildContext context) async {
  if (await permission.camera(context)) {
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
        title: Text(context.i18n.scanQRButtonText,
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
