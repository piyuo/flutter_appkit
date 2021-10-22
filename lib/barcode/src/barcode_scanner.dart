import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef CodeScanned = void Function(BuildContext context, String format, String code);

typedef QRCodeScanned = void Function(BuildContext context, String code);

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({
    Key? key,
    this.onCodeScanned,
    this.onQRCodeScanned,
  }) : super(key: key);

  /// onCodeScanned called when any barcode scanned
  final CodeScanned? onCodeScanned;

  /// onQRCodeScanned called when qr code scanned
  final QRCodeScanned? onQRCodeScanned;

  @override
  State<StatefulWidget> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  /// controller is QRView controller
  QRViewController? controller;

  /// qrKey is key QRView
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  /// hasPermission is null when permission not determine, true if has permission
  bool? hasPermission;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (kIsWeb) {
      return;
    }
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

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
    if (hasPermission == false) {
      return _noAccessToCamera(context);
    }

    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 200.0 : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
          if (widget.onCodeScanned != null) {
            widget.onCodeScanned!(
              context,
              scanData.format.formatName,
              scanData.code,
            );
          }
          if (widget.onQRCodeScanned != null && scanData.format == BarcodeFormat.qrcode) {
            widget.onQRCodeScanned!(
              context,
              scanData.code,
            );
          }
        });
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) =>
          (BuildContext context, QRViewController ctrl, bool gotPermission) => hasPermission = gotPermission,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
