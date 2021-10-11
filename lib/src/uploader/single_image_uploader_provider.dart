import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'uploader.dart';
import 'image_pick.dart';
import 'image_drop.dart';
import 'file.dart';

class SingleImageProvider with ChangeNotifier {
  SingleImageProvider({
    required this.uploader,
  });

  final Uploader uploader;

  bool dragging = false;

  bool busy = false;

  DropzoneViewController? _dropController;
  setDropController(DropzoneViewController dropController) {
    _dropController = dropController;
  }

  bool get isEmpty => uploader.isEmpty;

  String? get firstFile {
    if (uploader.isNotEmpty) {
      return uploader.filenames[0];
    }
    return null;
  }

  Future<void> pickImage(BuildContext context) async {
    final picked = await imagePick(context);
    if (picked != null) {
      _startUpload(context, picked);
    }
  }

  Future<void> dropImage(BuildContext context, dynamic file) async {
    dragging = false;
    if (_dropController == null) {
      notifyListeners();
      return;
    }

    final dropped = await imageDrop(context, _dropController!, file);
    _startUpload(context, dropped);
  }

  /// _startUpload start upload file to cloud
  Future<void> _startUpload(BuildContext context, File file) async {
    busy = true;
    notifyListeners();
    try {
      String? error = await uploader.upload(context, file, firstFile);
      if (error != null) {
        dialog.alert(context, error);
        return;
      }
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void error(BuildContext context, String? value) {
    if (value != null) {
      dialog.alert(context, value);
    }
  }

  void setDragging(BuildContext context, bool value) {
    if (dragging != value) {
      dragging = value;
      notifyListeners();
    }
  }
}
