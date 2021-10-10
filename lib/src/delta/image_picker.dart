import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class DeviceFile {
  DeviceFile({
    this.name,
    this.length,
    this.mimeType,
    this.bytes,
  });

  String? name;

  int? length;

  String? mimeType;

  Uint8List? bytes;

  /// notSelect is user not select any image file
  static DeviceFile notSelect = DeviceFile();

  /// mimeNotAccept is user selected image has not accept mime
  static DeviceFile mimeNotAccept = DeviceFile();

  /// too big is user selected image too big
  static DeviceFile tooBig = DeviceFile();
}

/// deterMimeType return determined mime type, return empty if can not determine
String deterMimeType(String? mimeType, String filename, Uint8List bytes) {
  if (mimeType != null) {
    return mimeType;
  }
  String? mime = lookupMimeType(filename);
  if (mime != null) {
    return mime;
  }

  // no luck on name, try header bytes
  mime = lookupMimeType(filename, headerBytes: bytes);
  if (mime != null) {
    return mime;
  }
  // nothing, return empty
  return '';
}

/// pickImage pick a image from device gallery, return null if not select or image type wrong
/// if using iOS or Android, image will shrink to prefer size default is 1280x1280
/// return notSelect, mimeNotAccept,tooBig
Future<DeviceFile> pickImage(
  BuildContext context, {
  Size preferSize = const Size(1280, 1280),
  int fileSizeMax = 10 * 1024 * 1024, // max 5MB
  List<String> acceptMIME = const ['image/png', 'image/jpeg', 'image/webp'],
}) async {
  final XFile? image = await ImagePicker().pickImage(
    maxWidth: preferSize.width,
    maxHeight: preferSize.height,
    source: ImageSource.gallery,
  );
  if (image == null) {
    return DeviceFile.notSelect;
  }

  final bytes = await image.readAsBytes();
  String mimeType = deterMimeType(image.mimeType, image.name, bytes);
  if (!acceptMIME.contains(mimeType)) {
    return DeviceFile.mimeNotAccept;
  }

  if (bytes.length > fileSizeMax) {
    return DeviceFile.tooBig;
  }

  return DeviceFile(
    name: image.name,
    length: bytes.length,
    bytes: bytes,
    mimeType: deterMimeType(image.mimeType, image.name, bytes),
  );
}
