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

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barCodes = capture.barcodes;
    for (final barcode in barCodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
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
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        controller: provide._controller,
        onDetect: provide.onDetect,
      );
    });
  }
}
