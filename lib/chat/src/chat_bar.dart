import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'chat_bar_embed.dart';
import 'chat_bar_provider.dart';

/// _kEmojiSize is a emoji size
const _kEmojiSize = 28.0;

class ChatBar extends StatelessWidget {
  const ChatBar({
    required this.messageEditorProvider,
    required this.onSend,
    super.key,
  });

  final ChatBarProvider messageEditorProvider;

  /// onSend is a callback function that will be called when user click send button
  final void Function(BuildContext context, List<pb.Word> words, Map<String, XFile>) onSend;

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
                    messageEditorProvider.showCameraBar(!messageEditorProvider.isCameraBarVisible);
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
                            ImageEmbedBuilder(chatBarProvider: messageEditorProvider),
                            VideoEmbedBuilder(chatBarProvider: messageEditorProvider),
                            FileEmbedBuilder(chatBarProvider: messageEditorProvider),
                            EmojiEmbedBuilder(),
                          ],
                          readOnly: false, // true for view only mode
                          maxHeight: 210,
                        )),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.insert_emoticon, color: colorScheme.secondary),
                          onPressed: () {
                            messageEditorProvider.showEmojiBar(!messageEditorProvider.isEmojiBarVisible);
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
                    final words = messageEditorProvider.toWords();
                    if (words.isEmpty) return;
                    final files = messageEditorProvider.files;
                    onSend(context, words, files); // async onSend call, so we can reset ASAP
                    messageEditorProvider.reset();
                  },
                ),
              ]),
              SizedBox(
                  height: messageEditorProvider.isCameraBarVisible ? 58 : 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: messageEditorProvider.isCameraBarVisible
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
                  height: messageEditorProvider.isEmojiBarVisible ? 150 : 0,
                  child: messageEditorProvider.isEmojiBarVisible
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
