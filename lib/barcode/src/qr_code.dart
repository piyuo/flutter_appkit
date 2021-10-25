import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  const QRCode({
    required this.data,
    this.advertiseOrReceipt = true,
    this.size = 300,
    Key? key,
  }) : super(key: key);

  /// advertiseOrReceipt in advertise will set errorCorrectionLevel to low to speed up qr code scan time
  /// in receipt mode will set errorCorrectionLevel to high to prevent QR code damaged
  final bool advertiseOrReceipt;

  /// size is QR code size
  final double size;

  /// data is QR code contain data
  final String data;

  @override
  Widget build(BuildContext context) {
    // always use black and white QR Code, it's traditional and effective.
    // don't use center icon image, it hard to see and may slow down scan QR code
    return QrImage(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: advertiseOrReceipt ? QrErrorCorrectLevel.L : QrErrorCorrectLevel.H,
      size: size,
      backgroundColor: Colors.white,
    );
  }
}
