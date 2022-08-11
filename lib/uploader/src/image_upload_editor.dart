import 'package:flutter/material.dart';
import 'package:libcli/editor/editor.dart' as editor;
import 'uploader.dart';
import 'image_upload_controller.dart';
import 'abstract_file.dart';

/// ImageUploadController upload single image through uploader
class ImageUploadEditor extends ImageUploadController {
  ImageUploadEditor({
    required Uploader uploader,
    this.cropAspectRatio = 1,
  }) : super(uploader: uploader);

  final double cropAspectRatio;

  /// onUpload upload image though uploader, child may override this method
  @override
  Future<String?> onUpload(BuildContext context, AbstractFile file, String? replaceFilename) async {
    final result = await editor.showImageEditor(
      context,
      cropAspectRatio: cropAspectRatio,
      bytes: await file.readAsBytes(),
    );
    if (result != null) {
      MemoryFile mf = MemoryFile(
        mimeType: file.mimeType,
        bytes: result,
      );
      return uploader.upload(mf, replaceFilename);
    }

    return uploader.upload(file, replaceFilename);
  }
}
