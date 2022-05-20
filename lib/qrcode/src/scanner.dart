import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// CodeScannedCallback called when a code has been scanned
typedef CodeScannedCallback = void Function(String? code);

/// ScannerProvider is scanner provider
class ScannerProvider with ChangeNotifier {
  ScannerProvider({
    required this.onCodeScanned,
  });

  /// onCodeScanned called when any barcode scanned
  final CodeScannedCallback onCodeScanned;

  /// controller is [MobileScannerController] controller
  final MobileScannerController _controller = MobileScannerController(torchEnabled: true);

  bool hasPermission = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onDetect(Barcode barcode, MobileScannerArguments? args) {
    if (barcode.rawValue == null) {
      debugPrint('Failed to scan Barcode');
    } else {
      final String code = barcode.rawValue!;
      debugPrint('Barcode found: $code');
      onCodeScanned(barcode.rawValue);
    }
  }
}

class Scanner extends StatelessWidget {
  const Scanner({
    Key? key,
  }) : super(key: key);

  Widget _noAccessToCamera(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(
          Icons.block,
          size: 72,
          color: Colors.red,
        ),
        SizedBox(height: 10),
        Text(
          'No access to camera',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(builder: (context, provide, child) {
      if (provide.hasPermission == false) {
        return _noAccessToCamera(context);
      }
      return MobileScanner(
        allowDuplicates: false,
        controller: provide._controller,
        onDetect: provide.onDetect,
      );
    });
  }
}
