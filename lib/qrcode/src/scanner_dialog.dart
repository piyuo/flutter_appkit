import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:libcli/permission/permission.dart' as permission;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'scanner.dart';

/// showScanner return scanned QR code or null if not scanned
Future<String?> showScanner(BuildContext context) async {
// todo:need check permission
//  if (await permission.camera) {
  return await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerDialog(),
      ));
//  }
//  return null;
}

class ScannerDialog extends StatelessWidget {
  const ScannerDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconTheme.of(context).copyWith(
            color: Colors.grey.shade400,
          ),
          centerTitle: true,
          title: Text(context.i18n.scanQRButtonText,
              style: TextStyle(
                color: Colors.grey[400],
              )),
          elevation: 0,
        ),
        body: ChangeNotifierProvider<ScannerProvider>(
          create: (context) => ScannerProvider(
            onCodeScanned: (code) {
              Navigator.pop(context, code);
            },
          ),
          child: const Scanner(),
        ));
  }
}
