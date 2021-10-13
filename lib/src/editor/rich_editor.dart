import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'rich_editor_provider.dart';

class RichEditor extends StatelessWidget {
  const RichEditor({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final RichEditorProvider controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 340,
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: QuillToolbar.basic(
                controller: controller.quill,
                multiRowsDisplay: false,
                showSmallButton: false,
                showInlineCode: false,
                showLink: false,
                showImageButton: false,
                showVideoButton: false,
                showCameraButton: false,
                showCodeBlock: false,
                showListCheck: false,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: QuillEditor.basic(
                controller: controller.quill,
                readOnly: false, // true for view only mode
              ),
            ))
          ],
        ));
  }
}
