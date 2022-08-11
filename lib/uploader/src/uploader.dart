import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'abstract_file.dart';

typedef ImageUploader = Future<String?> Function(Uint8List bytes, String? deleteFilename);

typedef ImageRemover = Future<void> Function(String filename);

/// UploaderErrorCode define error code return by upload
enum UploaderErrorCode { ok, uploadImageTooBig, uploadImageNotValid }

class Uploader with ChangeNotifier {
  Uploader({
    required this.filenames,
    required this.imageUploader,
    this.imageRemover,
    this.fileSizeMax = 5 * 1024 * 1024, // max 5MB
    this.acceptMIME = const ['image/png', 'image/jpeg', 'image/gif'],
  });
  //, 'image/x-icon'

  final int fileSizeMax;

  final List<String> acceptMIME;

  /// filenames keep all filenames
  List<String> filenames;

  final ImageUploader imageUploader;

  final ImageRemover? imageRemover;

  bool get isEmpty {
    return filenames.isEmpty;
  }

  bool get isNotEmpty {
    return filenames.isNotEmpty;
  }

  /// _errorUploadImageTooBig keep error message for later use
  String? _errorUploadImageTooBig;

  /// _errorUploadImageNotValid keep error message for later use
  String? _errorUploadImageNotValid;

  void prepare(BuildContext context) {
    // get error message now, cause no context can be use in upload
    _errorUploadImageTooBig = context.i18n.uploadImageTooBig;
    _errorUploadImageNotValid = context.i18n.uploadImageNotValid;
  }

  /// validate file, return null if OK, return error message if something wrong
  Future<String?> validate(AbstractFile file) async {
    assert(_errorUploadImageTooBig != null && _errorUploadImageNotValid != null, 'call prepare first');
    final fileSize = await file.getFileSize();
    final yourSize = i18n.formatBytes(fileSize, 1);
    if (fileSize > fileSizeMax) {
      final limit = i18n.formatBytes(fileSizeMax, 1);
      return _errorUploadImageTooBig!.replaceAll('%1', yourSize).replaceAll('%2', limit);
    }
    if (!acceptMIME.contains(file.mimeType)) {
      return _errorUploadImageNotValid!;
    }

    debugPrint('upload ${file.mimeType} $yourSize');
    return null;
  }

  Future<String?> upload(AbstractFile file, String? deleteFilename) async {
    assert(_errorUploadImageTooBig != null && _errorUploadImageNotValid != null, 'call prepare first');
    final error = await validate(file);
    if (error != null) {
      return error;
    }

    final bytes = await file.readAsBytes();
    String? result = await imageUploader(bytes, deleteFilename);
    if (result == null) {
      return null;
    }
    if (deleteFilename != null) {
      filenames.remove(deleteFilename);
    }
    filenames.add(result);
    notifyListeners();
    return result;
  }

  Future<void> delete(BuildContext context, String filename) async {
    assert(imageRemover != null, 'must set delete function');
    await imageRemover!(filename);
    filenames.remove(filename);
    notifyListeners();
  }
}
