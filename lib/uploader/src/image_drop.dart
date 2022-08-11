import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'abstract_file.dart';

class DropFile extends AbstractFile {
  DropFile({
    required this.dropController,
    required this.dropFile,
  });

  final DropzoneViewController dropController;

  final dynamic dropFile;

  /// getFileSize get the size of the file
  @override
  Future<int> getFileSize() => dropController.getFileSize(dropFile);

  /// readAsBytes synchronously read the entire file contents as a list of bytes.
  @override
  Future<Uint8List> readAsBytes() => dropController.getFileData(dropFile);
}

/// imageDrop process dropped file
Future<DropFile> imageDrop(BuildContext context, DropzoneViewController dropController, dynamic dropFile) async {
  final fileName = await dropController.getFilename(dropFile);
  final fileMime = await dropController.getFileMIME(dropFile);
  return DropFile(
    dropController: dropController,
    dropFile: dropFile,
  )..setMimeType(fileMime, fileName);
}
