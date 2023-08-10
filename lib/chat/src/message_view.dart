import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:chewie/chewie.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/utils/utils.dart' as utils;
import 'message_view_provider.dart';

/// _kBorderRadius is the border radius for embed
const _kBorderRadius = BorderRadius.all(Radius.circular(12));

/// _kEmojiSize is a emoji size
const _kEmojiSize = 28.0;

/// MessageView is a widget that display message
class MessageView extends StatelessWidget {
  const MessageView({
    required this.words,
    required this.messageViewProvider,
    this.textStyle,
    this.mediaConstraints,
    super.key,
  });

  /// words is a list of words that will be display
  final List<pb.Word> words;

  /// messageViewProvider provide video controller to MessageView
  final MessageViewProvider messageViewProvider;

  /// textStyle for message
  final TextStyle? textStyle;

  /// mediaConstraints is the image constraints
  final BoxConstraints? mediaConstraints;

  /// _isSingleMedia return true if words is a single media
  bool get _isSingleMedia => isSingleMedia(words);

  @override
  Widget build(BuildContext context) {
    buildEmbed(Widget child) {
      final result = Container(
          constraints: mediaConstraints,
          child: Padding(
            padding: EdgeInsets.all(_isSingleMedia ? 0 : 10),
            child: child,
          ));

      if (_isSingleMedia) {
        return result;
      }
      return Align(child: result);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: words.map((word) {
        switch (word.type) {
          case pb.Word_WordType.WORD_TYPE_TEXT:
            return Text(word.value, style: textStyle);
          case pb.Word_WordType.WORD_TYPE_EMOJI:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(word.value, style: const TextStyle(fontSize: _kEmojiSize)),
            );
          case pb.Word_WordType.WORD_TYPE_IMAGE:
            return buildEmbed(
              delta.WebImage(
                url: messageViewProvider.urlBuilder(word.type, word.value),
                borderRadius: _isSingleMedia ? null : _kBorderRadius,
              ),
            );
          case pb.Word_WordType.WORD_TYPE_VIDEO:
            if (UniversalPlatform.isDesktop) {
              return buildEmbed(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 45),
                  color: Colors.grey.withOpacity(.7),
                  child: IconButton(
                      onPressed: () {
                        utils.openUrl(messageViewProvider.urlBuilder(word.type, word.value));
                      },
                      icon: const Icon(
                        size: 46,
                        Icons.play_circle,
                      )),
                ),
              );
            }

            final videoPlayer = messageViewProvider.getVideoPlayerById(word.value);
            if (videoPlayer == null) {
              //video player not load yet
              return buildEmbed(
                const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      size: 46,
                      Icons.play_circle,
                    )),
              );
            }

            return buildEmbed(ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                  aspectRatio: videoPlayer.videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: videoPlayer,
                  )),
            ));

          default:
        }
        return const SizedBox();
      }).toList(),
    );
  }
}

/// isSingleMedia return true if words is a single media
bool isSingleMedia(List<pb.Word> words) {
  return words.length == 1 &&
      (words[0].type == pb.Word_WordType.WORD_TYPE_IMAGE || words[0].type == pb.Word_WordType.WORD_TYPE_VIDEO);
}
