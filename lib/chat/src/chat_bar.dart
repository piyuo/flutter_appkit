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
    required this.chatBarProvider,
    required this.onSend,
    super.key,
  });

  /// chatBarProvider provide chat bar state
  final ChatBarProvider chatBarProvider;

  /// onSend called when user click send button, return true if send success
  final Future<bool> Function(BuildContext context, List<pb.Word> words, Map<String, XFile>) onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
        builder: (context, constraints) => Container(
            color: colorScheme.secondaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                IconButton(
                  icon: Icon(Icons.photo_camera, color: colorScheme.secondary),
                  onPressed: () async {
                    if (UniversalPlatform.isDesktop || UniversalPlatform.isWeb) {
                      final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                      chatBarProvider.insertFiles(picked);
                      return;
                    }
                    chatBarProvider.showCameraBar(!chatBarProvider.isCameraBarVisible);
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: QuillEditor(
                            readOnly: false,
                            focusNode: chatBarProvider.focusNode,
                            scrollController: chatBarProvider.scrollController,
                            scrollable: true,
                            padding: const EdgeInsets.fromLTRB(20, 6, 5, 8),
                            autoFocus: false,
                            expands: false,
                            controller: chatBarProvider.quillController,
                            embedBuilders: [
                              ImageEmbedBuilder(chatBarProvider: chatBarProvider),
                              VideoEmbedBuilder(chatBarProvider: chatBarProvider),
                              FileEmbedBuilder(chatBarProvider: chatBarProvider),
                              EmojiEmbedBuilder(),
                            ],
                            maxHeight: 210,
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.insert_emoticon, color: colorScheme.secondary),
                          onPressed: () {
                            chatBarProvider.showEmojiBar(!chatBarProvider.isEmojiBarVisible);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: 54,
                    child: IconButton(
                      icon: Icon(Icons.send_outlined, color: colorScheme.secondary),
                      onPressed: () async {
                        final words = chatBarProvider.toWords();
                        if (words.isEmpty) return;
                        final files = chatBarProvider.files;
                        final ok = await onSend(context, words, files); // async onSend call, so we can reset ASAP
                        if (ok) {
                          chatBarProvider.reset();
                        }
                      },
                    )),
              ]),
              SizedBox(
                  height: chatBarProvider.isCameraBarVisible ? 58 : 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: chatBarProvider.isCameraBarVisible
                          ? Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      chatBarProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraPhoto);
                                      chatBarProvider.insertFiles(picked);
                                    },
                                    child: const Text('Photo')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () async {
                                      chatBarProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.cameraVideo);
                                      chatBarProvider.insertFiles(picked);
                                    },
                                    child: const Text('Video')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () async {
                                      chatBarProvider.showCameraBar(false);
                                      final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                                      chatBarProvider.insertFiles(picked);
                                    },
                                    child: const Text('Gallery')),
                              ],
                            )
                          : null)),
              SizedBox(
                  height: chatBarProvider.isEmojiBarVisible ? 150 : 0,
                  child: chatBarProvider.isEmojiBarVisible
                      ? EmojiPicker(
                          onEmojiSelected: (category, Emoji emoji) {
                            chatBarProvider.insertEmoji(emoji.emoji);
                            chatBarProvider.showEmojiBar(false);
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
