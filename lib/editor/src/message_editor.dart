import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:video_player/video_player.dart';
import 'message_embed.dart';
import 'message_editor_video.dart';

/// isVideoPlayerAvailable return true if file is video and can play on current platform
bool isVideoPlayerAvailable(XFile file) => !UniversalPlatform.isWeb && !UniversalPlatform.isDesktop && file.isVideo;

class MessageEditorProvider with ChangeNotifier {
  /// quillController is a controller for QuillEditor
  QuillController quillController = QuillController.basic();

  /// focusNode is a focus node for QuillEditor
  FocusNode focusNode = FocusNode();

  /// scrollController is a scroll controller for QuillEditor
  ScrollController scrollController = ScrollController();

  /// _files keep track of all files that user selected
  final Map<String, XFile> _files = {};

  /// _videoPlayers keep track of all videoPlayers
  final Map<String, VideoPlayerController> _videoPlayers = {};

  /// getFiles return file by id
  XFile getFileById(String id) => _files[id]!;

  /// getVideoPlayerById return video player by id
  VideoPlayerController getVideoPlayerById(String id) => _videoPlayers[id]!;

  /// _isCameraToolBoxVisible is a flag to show/hide camera toolbox
  bool _isCameraToolBoxVisible = false;

  /// reset clear all data, let user start from scratch
  void reset() {
    for (final entry in _videoPlayers.entries) {
      entry.value.dispose();
    }
    _videoPlayers.clear();
    _files.clear();
    quillController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  void removeMedia(String id) {
    _files.remove(id);
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
  Future<void> insertFiles(List<XFile> files) async {
    for (int i = files.length - 1; i >= 0; i--) {
      final file = files[i];
      final id = utils.uuid();
      _files[id] = file;

      if (isVideoPlayerAvailable(file)) {
        _videoPlayers[id] = await initVideoPlayerController(file);
      }
      quillController.document.insert(quillController.selection.baseOffset, getFileEmbed(id, file));
      quillController.moveCursorToPosition(quillController.selection.baseOffset + 1);
    }
    notifyListeners();
    focusNode.requestFocus();
  }

  /// hasText return true if quillController.document.length > 0
  bool get hasText => quillController.document.length > 0;

  pb.Word_WordType getTypeFromEmbed(String key) {
    switch (key) {
      case kImageKey:
        return pb.Word_WordType.WORD_TYPE_IMAGE;
      case kVideoKey:
        return pb.Word_WordType.WORD_TYPE_VIDEO;
      case kFileKey:
        return pb.Word_WordType.WORD_TYPE_FILE;
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
          words.add(pb.Word(
            type: getTypeFromEmbed(entry.key),
            value: entry.value,
          ));
          if (entry.key == kImageKey) {}
        }
      }
    }
    return words;
  }

  /// showCameraToolBox show/hide camera toolbox
  void showCameraToolBox(bool visible) {
    _isCameraToolBoxVisible = visible;
    notifyListeners();
  }
}

class MessageEditor extends StatelessWidget {
  const MessageEditor({
    required this.messageEditorProvider,
    required this.onSend,
    super.key,
  });

  final MessageEditorProvider messageEditorProvider;

  /// onSend is a callback function that will be called when user click send button
  final Future<void> Function(List<pb.Word> words, Map<String, XFile>) onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
        color: colorScheme.secondaryContainer,
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          Row(children: [
            IconButton(
              icon: Icon(Icons.photo_camera, color: colorScheme.secondary),
              onPressed: () async {
                if (UniversalPlatform.isDesktop || UniversalPlatform.isWeb) {
                  final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                  messageEditorProvider.insertFiles(picked);
                  return;
                }

                messageEditorProvider.showCameraToolBox(!messageEditorProvider._isCameraToolBoxVisible);
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.secondary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    Expanded(
                        child: QuillEditor(
                      focusNode: messageEditorProvider.focusNode,
                      scrollController: messageEditorProvider.scrollController,
                      scrollable: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      autoFocus: false,
                      expands: false,
                      controller: messageEditorProvider.quillController,
                      embedBuilders: [
                        ImageEmbedBuilder(messageEditorProvider: messageEditorProvider),
                        VideoEmbedBuilder(messageEditorProvider: messageEditorProvider),
                        FileEmbedBuilder(messageEditorProvider: messageEditorProvider),
                      ],
                      readOnly: false, // true for view only mode
                      maxHeight: 210,
                    )),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.insert_emoticon, color: colorScheme.secondary),
                      onPressed: () async {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.send_outlined, color: colorScheme.secondary),
              onPressed: () async {
                if (messageEditorProvider.hasText) {
                  await onSend(messageEditorProvider.toWords(), messageEditorProvider._files);
                }
                messageEditorProvider.reset();
              },
            ),
          ]),
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: messageEditorProvider._isCameraToolBoxVisible ? 58 : 0,
              child: messageEditorProvider._isCameraToolBoxVisible
                  ? Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              messageEditorProvider.showCameraToolBox(false);
                              final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraPhoto);
                              messageEditorProvider.insertFiles(picked);
                            },
                            child: const Text('Photo')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () async {
                              messageEditorProvider.showCameraToolBox(false);
                              final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraVideo);
                              messageEditorProvider.insertFiles(picked);
                            },
                            child: const Text('Video')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () async {
                              messageEditorProvider.showCameraToolBox(false);
                              final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                              messageEditorProvider.insertFiles(picked);
                            },
                            child: const Text('Gallery')),
                      ],
                    )
                  : null)
        ]));
  }
}
