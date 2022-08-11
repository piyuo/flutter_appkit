import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'abstract_file.dart';

class GalleryFile extends AbstractFile {
  GalleryFile({
    required this.picked,
  });

  final XFile picked;

  /// getFileSize get the size of the file
  @override
  Future<int> getFileSize() => picked.length();

  /// readAsBytes synchronously read the entire file contents as a list of bytes.
  @override
  Future<Uint8List> readAsBytes() => picked.readAsBytes();
}

/// imagePick pick a image from device gallery, return null if not select or image type wrong
Future<GalleryFile?> imagePick({
  Size preferSize = const Size(1280, 1280),
}) async {
  final XFile? picked = await ImagePicker().pickImage(
    maxWidth: preferSize.width,
    maxHeight: preferSize.height,
    source: ImageSource.gallery,
  );
  if (picked == null) {
    return null;
  }
  return GalleryFile(
    picked: picked,
  )..setMimeType(picked.mimeType, picked.name);
}
