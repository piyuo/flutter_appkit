import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// QrImage generate qr code image
class QrImage extends StatelessWidget {
  /// ```dart
  /// final image=const QrImage(
  ///   data: 'http://cacake.piyuo.com/location=12348234234s',
  /// )
  /// ```
  const QrImage({
    required this.data,
    this.size = 300,
    super.key,
  });

  /// size is QR code size
  final double size;

  /// data is QR code contain data
  final String data;

  @override
  Widget build(BuildContext context) {
    // always use black and white QR Code, it's traditional and effective.
    // don't use center icon image, it hard to see and may slow down scan QR code
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      //errorCorrectionLevel: highCorrectionLevel ? QrErrorCorrectLevel.H : QrErrorCorrectLevel.L,
      size: size,
      backgroundColor: Colors.white,
    );
  }
}
