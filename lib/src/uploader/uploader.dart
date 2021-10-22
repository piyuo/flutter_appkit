import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'file.dart';
import 'l10n.dart';

typedef UploadFunc = Future<String?> Function(BuildContext context, Uint8List bytes, String? deleteFilename);

typedef DeleteFunc = Future<void> Function(BuildContext context, String filename);

class Uploader with ChangeNotifier {
  Uploader({
    required this.filenames,
    required this.uploadFunc,
    this.deleteFunc,
    this.fileSizeMax = 5 * 1024 * 1024, // max 5MB
    this.acceptMIME = const ['image/png', 'image/jpeg', 'image/gif'],
  });
  //, 'image/x-icon'

  final int fileSizeMax;

  final List<String> acceptMIME;

  /// filenames keep all filenames
  List<String> filenames;

  final UploadFunc uploadFunc;

  final DeleteFunc? deleteFunc;

  bool get isEmpty {
    return filenames.isEmpty;
  }

  bool get isNotEmpty {
    return filenames.isNotEmpty;
  }

  /// validate file, return null if OK, return error message if something wrong
  Future<String?> validate(File file) async {
    final fileSize = await file.getFileSize();
    final yourSize = i18n.formatBytes(fileSize, 1);
    if (fileSize > fileSizeMax) {
      final limit = i18n.formatBytes(fileSizeMax, 1);
      return 'tooBig'.l10n.replaceAll('%1', yourSize).replaceAll('%2', limit);
    }
    if (!acceptMIME.contains(file.mimeType)) {
      return 'notValid'.l10n;
    }

    debugPrint('upload ${file.mimeType} $yourSize');
    return null;
  }

  Future<String?> upload(BuildContext context, File file, String? deleteFilename) async {
    final error = await validate(file);
    if (error != null) {
      return error;
    }

    final bytes = await file.readAsBytes();
    String? result = await uploadFunc(context, bytes, deleteFilename);
    if (result == null) {
      return null;
    }
    if (deleteFilename != null) {
      filenames.remove(deleteFilename);
    }
    filenames.add(result);
    notifyListeners();
  }

  Future<void> delete(BuildContext context, String filename) async {
    assert(deleteFunc != null, 'must set delete function');
    await deleteFunc!(context, filename);
    filenames.remove(filename);
    notifyListeners();
  }
}
