import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'image_editor.dart';

Future<Uint8List?> showImageEditor(
  BuildContext context, {
  String? url,
  Uint8List? bytes,
  double cropAspectRatio = 1,
}) async {
  return Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageEditorDialog(
          url: url,
          bytes: bytes,
          cropAspectRatio: cropAspectRatio,
        ),
      ));
}

Widget _iconButton(IconData ico, String tooltip, VoidCallback onPressed) => IconButton(
      icon: Icon(ico),
      tooltip: tooltip,
      iconSize: 28.0,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      onPressed: onPressed,
    );

class ImageEditorDialog extends StatelessWidget {
  const ImageEditorDialog({
    this.url,
    this.bytes,
    this.cropAspectRatio = 1,
    Key? key,
  }) : super(key: key);

  final Uint8List? bytes;

  final String? url;

  final double cropAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageEditorProvider>(
      create: (context) => ImageEditorProvider(
        url: url,
        bytes: bytes,
      ),
      child: Consumer<ImageEditorProvider>(builder: (context, provide, child) {
        onSave() async {
          dialog.toastWaitFor(
            callback: () async {
              final navigator = Navigator.of(context);
              final bytes = await provide.crop();
              debugPrint('${bytes.length}');
              navigator.pop();
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: onSave,
                  child: Text(context.i18n.imageSaveButtonText),
                ),
              )
            ],
            titleSpacing: 0,
            title: Text(context.i18n.imageResizeButtonText),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ImageEditor(
                  controller: provide,
                  cropAspectRatio: cropAspectRatio,
                ),
              ),
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: IntrinsicWidth(
                    child: Card(
                      elevation: 5,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        _iconButton(Icons.flip, context.i18n.imageFlipButtonText, () => provide.flip()),
                        _iconButton(Icons.rotate_left, context.i18n.imageRotateLeftButtonText,
                            () => provide.rotate(right: false)),
                        _iconButton(Icons.rotate_right, context.i18n.imageRotateRightButtonText,
                            () => provide.rotate(right: true)),
                        _iconButton(Icons.restore, context.i18n.imageResetButtonText, () => provide.reset()),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))),
                            onPressed: onSave,
                            child: Text(context.i18n.imageSaveButtonText),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
