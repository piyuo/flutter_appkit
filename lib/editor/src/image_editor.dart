import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
//import 'image_editor_helper.dart';

class ImageEditorProvider with ChangeNotifier {
  ImageEditorProvider({
    this.url,
    this.bytes,
  }) : assert(url != null || bytes != null, 'must have image url or bytes');

  Uint8List? bytes;

  final String? url;

  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey<ExtendedImageEditorState>();

  /// setBytes set image raw data
  void setBytes(Uint8List src) {
    bytes = src;
    notifyListeners();
  }

  /// flip image
  void flip() {
    _editorKey.currentState!.flip();
  }

  /// rotate image
  void rotate({
    bool right = false,
  }) {
    _editorKey.currentState!.rotate(right: right);
  }

  /// reset image
  void reset() {
    _editorKey.currentState!.reset();
  }

  // todo:need crop
  /// crop current image and return new one
  //Future<Uint8List> crop() => cropImageDataWithDartLibrary(state: _editorKey.currentState!);
}

class ImageEditor extends StatelessWidget {
  const ImageEditor({
    required this.controller,
    this.cropAspectRatio = 1,
    Key? key,
  }) : super(key: key);

  final double cropAspectRatio;

  final ImageEditorProvider controller;

  @override
  Widget build(BuildContext context) {
    final config = EditorConfig(
      maxScale: 8.0,
      cropRectPadding: const EdgeInsets.all(20.0),
      hitTestSize: 20.0,
      cropAspectRatio: 1,
      cornerColor: Colors.blue,
    );

    if (controller.bytes != null) {
      return ExtendedImage.memory(
        controller.bytes!,
        extendedImageEditorKey: controller._editorKey,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        initEditorConfigHandler: (state) => config,
      );
    }

    return ExtendedImage.network(
      controller.url!,
      extendedImageEditorKey: controller._editorKey,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.editor,
      initEditorConfigHandler: (state) => config,
      cacheRawData: true,
    );
  }
}
