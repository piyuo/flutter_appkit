import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'uploader.dart';
import 'image_pick.dart';
import 'image_drop.dart';
import 'file.dart';

/// ImageUploadController upload single image through uploader
class ImageUploadController with ChangeNotifier {
  ImageUploadController({
    required this.uploader,
  });

  /// uploader upload file to remote
  final Uploader uploader;

  /// dragging is true if user is dragging
  bool dragging = false;

  /// busy to upload
  bool busy = false;

  /// _dropController is drop zone controller
  DropzoneViewController? _dropController;

  /// setDropController set drop zone controller
  void setDropController(DropzoneViewController dropController) => _dropController = dropController;

  /// isEmpty return true if uploader is empty
  bool get isEmpty => uploader.isEmpty;

  /// firstFile is first file in uploader
  String? get firstFile {
    if (uploader.isNotEmpty) {
      return uploader.filenames[0];
    }
    return null;
  }

  /// pickImage pick image from device and upload
  Future<void> pickImage(BuildContext context) async {
    final picked = await imagePick(context);
    if (picked != null) {
      startUpload(context, picked);
    }
  }

  /// dropImage accept dropped image and upload
  Future<void> dropImage(BuildContext context, dynamic file) async {
    dragging = false;
    if (_dropController == null) {
      notifyListeners();
      return;
    }

    final dropped = await imageDrop(context, _dropController!, file);
    startUpload(context, dropped);
  }

  /// onUpload upload image though uploader, child may override this method
  Future<String?> onUpload(BuildContext context, File file, String? replaceFilename) =>
      uploader.upload(context, file, replaceFilename);

  /// startUpload start upload file to cloud
  Future<void> startUpload(BuildContext context, File file) async {
    busy = true;
    notifyListeners();
    try {
      String? error = await onUpload(context, file, firstFile);
      if (error != null) {
        dialog.alert(context, error);
        return;
      }
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  /// setDragging set dragging to true
  void setDragging(BuildContext context, bool value) {
    if (dragging != value) {
      dragging = value;
      notifyListeners();
    }
  }
}
