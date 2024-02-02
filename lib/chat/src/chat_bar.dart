import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/net/net.dart' as net;
import 'package:universal_platform/universal_platform.dart';

import 'chat_bar_embed.dart';
import 'chat_bar_provider.dart';

/// _kEmojiSize is a emoji size
const _kEmojiSize = 28.0;

class ChatBar extends StatelessWidget {
  /// chatBarProvider provide chat bar state
  final ChatBarProvider chatBarProvider;

  /// onSend called when user click send button, return true if send success
  final Future<bool> Function(BuildContext context, List<net.Word> words, Map<String, XFile>) onSend;

  /// color is the color of the icon and border
  final Color? color;

  const ChatBar({
    required this.chatBarProvider,
    required this.onSend,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  IconButton(
                    icon: Icon(Icons.photo_camera, color: color),
                    onPressed: () async {
                      if (UniversalPlatform.isDesktop || UniversalPlatform.isWeb) {
                        final picked = await delta.pickMedia(mediaType: delta.MediaType.gallery);
                        chatBarProvider.insertFiles(picked);
                        return;
                      }
                      chatBarProvider.showCameraBar(!chatBarProvider.isCameraBarVisible);
                    },
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: color ?? colorScheme.secondary,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: QuillEditor(
                              configurations: QuillEditorConfigurations(
                                controller: chatBarProvider.quillController,
                                readOnly: false,
                                scrollable: true,
                                padding: const EdgeInsets.fromLTRB(20, 6, 5, 8),
                                autoFocus: false,
                                expands: false,
                                embedBuilders: [
                                  ImageEmbedBuilder(chatBarProvider: chatBarProvider),
                                  VideoEmbedBuilder(chatBarProvider: chatBarProvider),
                                  FileEmbedBuilder(chatBarProvider: chatBarProvider),
                                  EmojiEmbedBuilder(),
                                ],
                                maxHeight: 210,
                              ),
                              focusNode: chatBarProvider.focusNode,
                              scrollController: chatBarProvider.scrollController,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.insert_emoticon, color: color),
                                onPressed: () {
                                  chatBarProvider.showEmojiBar(!chatBarProvider.isEmojiBarVisible);
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 54,
                      child: IconButton(
                        icon: Icon(Icons.send_outlined, color: color),
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
                              categoryViewConfig: CategoryViewConfig(
                                backgroundColor: Colors.transparent,
                                iconColor: colorScheme.secondary,
                                iconColorSelected: colorScheme.primary,
                                indicatorColor: colorScheme.primary,
                                recentTabBehavior: RecentTabBehavior.NONE,
                              ),
                              bottomActionBarConfig: const BottomActionBarConfig(),
                              emojiViewConfig: EmojiViewConfig(
                                columns: (constraints.maxWidth / (_kEmojiSize + 15)).ceil(),
                                emojiSizeMax: _kEmojiSize,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          )
                        : null),
              ],
            ));
  }
}
