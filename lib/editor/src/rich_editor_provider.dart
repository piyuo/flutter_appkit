import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class RichEditorProvider with ChangeNotifier {
  RichEditorProvider({
    String json = '',
  }) {
    if (json.isNotEmpty) {
      final jsonStr = jsonDecode(json);
      quill = QuillController(
        document: Document.fromJson(jsonStr),
        selection: const TextSelection.collapsed(offset: 0),
      );
      return;
    }
    quill = QuillController.basic();
  }

  late QuillController quill;

  String toJSON() => jsonEncode(quill.document.toDelta().toJson());
}
