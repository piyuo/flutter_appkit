import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:video_player/video_player.dart';
import 'package:universal_io/io.dart';
import 'chat_bar_embed.dart';

/// insertFiles insert video or image at current index
Future<VideoPlayerController> initVideoPlayerController(XFile file) async {
  final controller = VideoPlayerController.file(File(file.path));
  await controller.initialize();
  return controller;
}

class ChatBarProvider with ChangeNotifier {
  /// quillController is a controller for QuillEditor
  QuillController quillController = QuillController.basic();

  /// focusNode is a focus node for QuillEditor
  FocusNode focusNode = FocusNode();

  /// scrollController is a scroll controller for QuillEditor
  ScrollController scrollController = ScrollController();

  /// files keep track of all files that user selected
  final Map<String, XFile> files = {};

  /// mediaSizes keep track of all media ratios
  final Map<String, Size> mediaSizes = {};

  /// getFiles return file by id
  XFile getFileById(String id) => files[id]!;

  /// isCameraBarVisible is a flag to show/hide camera toolbar
  bool isCameraBarVisible = false;

  /// isEmojiBarVisible is a flag to show/hide emoji toolbar
  bool isEmojiBarVisible = false;

  /// reset clear all data, let user start from scratch
  void reset() {
    files.clear();
    mediaSizes.clear();
    quillController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    quillController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// hasText return true if quillController.document.length > 0
  bool get hasText => quillController.document.length > 0;

  /// hasMediaSizes return true if media already set it's ratio
  bool hasMediaSizes(String id) => mediaSizes.containsKey(id);

  /// setMediaSize set media ratio
  void setMediaSize(String id, Size value) => mediaSizes[id] = value;

  /// removeFile remove file
  void removeFile(String id) {
    files.remove(id);
    notifyListeners();
  }

  /// GetFileEmbed return embed by file type
  CustomBlockEmbed getFileEmbed(String id, XFile file) {
    if (file.isVideo) {
      return VideoEmbed(id);
    }
    if (file.isImage) {
      return ImageEmbed(id);
    }
    return FileEmbed(id);
  }

  /// insertFiles insert video or image at current index
  Future<void> insertFiles(List<XFile> newFiles) async {
    for (int i = newFiles.length - 1; i >= 0; i--) {
      final file = newFiles[i];
      final id = utils.uuid();
      files[id] = file;

      quillController.document.insert(quillController.selection.baseOffset, getFileEmbed(id, file));
      quillController.moveCursorToPosition(quillController.selection.baseOffset + 1);
    }
    notifyListeners();
    focusNode.requestFocus();
  }

  /// insertEmoji insert emoji at current index
  Future<void> insertEmoji(String emoji) async {
    quillController.document.insert(quillController.selection.baseOffset, EmojiEmbed(emoji));
    quillController.moveCursorToPosition(quillController.selection.baseOffset + 1);
    notifyListeners();
    focusNode.requestFocus();
/*    final a = Attribute.clone(Attribute.bold, null);
    quillController.document.insert(0, emoji);
    quillController.formatText(0, emoji.length, Attribute.bold);
    quillController.document.insert(emoji.length, 'x');
    quillController.formatText(emoji.length, 1, a);
    quillController.document.insert(quillController.selection.baseOffset, emoji);
    quillController.formatText(quillController.selection.baseOffset, emoji.length, Attribute.bold);
    quillController.formatText(quillController.selection.baseOffset + emoji.length, 1, a);
    quillController.moveCursorToPosition(quillController.selection.baseOffset + emoji.length);
*/
  }

  /// getTypeFromEmbed return pb.Word_WordType from embed key
  pb.Word_WordType getTypeFromEmbed(String key) {
    switch (key) {
      case kImageKey:
        return pb.Word_WordType.WORD_TYPE_IMAGE;
      case kVideoKey:
        return pb.Word_WordType.WORD_TYPE_VIDEO;
      case kFileKey:
        return pb.Word_WordType.WORD_TYPE_FILE;
      case kEmojiKey:
        return pb.Word_WordType.WORD_TYPE_EMOJI;
      default:
        return pb.Word_WordType.WORD_TYPE_UNSPECIFIED;
    }
  }

  /// toWords convert quillController.document to List<pb.Word>
  List<pb.Word> toWords() {
    final words = <pb.Word>[];
    final operations = quillController.document.toDelta().toList();
    for (int i = 0; i < operations.length; i++) {
      final operation = operations[i];
      if (operation.data is String) {
        String text = operation.data as String;
        if (text.isEmpty || (i == text.length - 1 && text.trim() == '\n')) continue;
        words.add(pb.Word(type: pb.Word_WordType.WORD_TYPE_TEXT, value: text));
      } else if (operation.data is Map) {
        for (final entry in (operation.data as Map).entries) {
          final type = getTypeFromEmbed(entry.key);
          Size? size;
          if (type == pb.Word_WordType.WORD_TYPE_IMAGE || type == pb.Word_WordType.WORD_TYPE_VIDEO) {
            size = mediaSizes[entry.value];
          }
          words.add(
            pb.Word(
              type: type,
              value: entry.value,
              width: size?.width.round(),
              height: size?.height.round(),
            ),
          );
        }
      }
    }
    return words;
  }

  /// showCameraBar show/hide camera toolbar
  void showCameraBar(bool visible) {
    isCameraBarVisible = visible;
    isEmojiBarVisible = false;
    notifyListeners();
  }

  /// showEmojiBar show/hide camera toolbar
  void showEmojiBar(bool visible) {
    isEmojiBarVisible = visible;
    isCameraBarVisible = false;
    notifyListeners();
  }
}
