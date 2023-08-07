import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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

/// _kEmojiSize is a emoji size
const _kEmojiSize = 28.0;

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

  /// _isCameraBarVisible is a flag to show/hide camera toolbar
  bool _isCameraBarVisible = false;

  /// _isEmojiBarVisible is a flag to show/hide emoji toolbar
  bool _isEmojiBarVisible = false;

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

  /// hasText return true if quillController.document.length > 0
  bool get hasText => quillController.document.length > 0;

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
          words.add(
            pb.Word(
              type: getTypeFromEmbed(entry.key),
              value: entry.value,
            ),
          );
          if (entry.key == kImageKey) {}
        }
      }
    }
    return words;
  }

  /// showCameraBar show/hide camera toolbar
  void showCameraBar(bool visible) {
    _isCameraBarVisible = visible;
    _isEmojiBarVisible = false;
    notifyListeners();
  }

  /// showEmojiBar show/hide camera toolbar
  void showEmojiBar(bool visible) {
    _isEmojiBarVisible = visible;
    _isCameraBarVisible = false;
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
    return LayoutBuilder(
        builder: (context, constraints) => Container(
            color: colorScheme.secondaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 5),
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
                    messageEditorProvider.showCameraBar(!messageEditorProvider._isCameraBarVisible);
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          autoFocus: false,
                          expands: false,
                          controller: messageEditorProvider.quillController,
                          embedBuilders: [
                            ImageEmbedBuilder(messageEditorProvider: messageEditorProvider),
                            VideoEmbedBuilder(messageEditorProvider: messageEditorProvider),
                            FileEmbedBuilder(messageEditorProvider: messageEditorProvider),
                            EmojiEmbedBuilder(),
                          ],
                          readOnly: false, // true for view only mode
                          maxHeight: 210,
                        )),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.insert_emoticon, color: colorScheme.secondary),
                          onPressed: () {
                            messageEditorProvider.showEmojiBar(!messageEditorProvider._isEmojiBarVisible);
                          },
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
              SizedBox(
                  height: messageEditorProvider._isCameraBarVisible ? 58 : 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: messageEditorProvider._isCameraBarVisible
                          ? Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      messageEditorProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraPhoto);
                                      messageEditorProvider.insertFiles(picked);
                                    },
                                    child: const Text('Photo')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () async {
                                      messageEditorProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraVideo);
                                      messageEditorProvider.insertFiles(picked);
                                    },
                                    child: const Text('Video')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () async {
                                      messageEditorProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                                      messageEditorProvider.insertFiles(picked);
                                    },
                                    child: const Text('Gallery')),
                              ],
                            )
                          : null)),
              SizedBox(
                  height: messageEditorProvider._isEmojiBarVisible ? 150 : 0,
                  child: messageEditorProvider._isEmojiBarVisible
                      ? EmojiPicker(
                          onEmojiSelected: (category, Emoji emoji) {
                            messageEditorProvider.insertEmoji(emoji.emoji);
                            messageEditorProvider.showEmojiBar(false);
                          },
                          config: Config(
                            columns: (constraints.maxWidth / (_kEmojiSize + 15)).ceil(),
                            bgColor: Colors.transparent,
                            iconColor: colorScheme.secondary,
                            iconColorSelected: colorScheme.primary,
                            indicatorColor: colorScheme.primary,
                            emojiSizeMax: _kEmojiSize,
                            recentTabBehavior: RecentTabBehavior.NONE,
                          ),
                        )
                      : null),
            ])));
  }
}
