import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:cross_file_image/cross_file_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'chat_bar_provider.dart';

/// kImageKey is [ImageEmbed] key.
const kImageKey = 'i';

/// kVideoKey is [VideoEmbed] key.
const kVideoKey = 'v';

/// kFileKey is [FileEmbed] key.
const kFileKey = 'f';

/// kEmojiKey is [EmojiEmbed] key.
const kEmojiKey = 'e';

/// ImageEmbed is a custom block embed for image.
class ImageEmbed extends CustomBlockEmbed {
  const ImageEmbed(String value) : super(kImageKey, value);
}

/// VideoEmbed is a custom block embed for video.
class VideoEmbed extends CustomBlockEmbed {
  const VideoEmbed(String value) : super(kVideoKey, value);
}

/// FileEmbed is a custom block embed for file.
class FileEmbed extends CustomBlockEmbed {
  const FileEmbed(String value) : super(kFileKey, value);
}

/// EmojiEmbed is a custom block embed for emoji.
class EmojiEmbed extends CustomBlockEmbed {
  const EmojiEmbed(String value) : super(kEmojiKey, value);
}

class EmojiEmbedBuilder extends EmbedBuilder {
  @override
  String get key => kEmojiKey;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final emoji = node.value.data;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

/// MediaEmbed is a custom block embed for image/video/file
abstract class MediaEmbedBuilder extends EmbedBuilder {
  MediaEmbedBuilder({
    required this.messageEditorProvider,
  });

  final ChatBarProvider messageEditorProvider;

  @override
  bool get expanded => false;

  /// buildThumb build the thumbnail for the embed
  Widget buildThumb(BuildContext context, String id, XFile file);

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final id = node.value.data;
    final file = messageEditorProvider.getFileById(id);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(children: [
        ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 170,
              maxHeight: 170,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: buildThumb(context, id, file),
            )),
        Positioned(
          top: 3,
          right: 3,
          child: Container(
              constraints: const BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: IconButton(
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                color: colorScheme.onTertiaryContainer,
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.document.delete(node.documentOffset, 1);
                  messageEditorProvider.removeMedia(node.value.data);
                },
              )),
        ),
      ]),
    );
  }
}

/// ImageEmbedBuilder is a custom embed builder for [ImageEmbed].
class ImageEmbedBuilder extends MediaEmbedBuilder {
  ImageEmbedBuilder({
    required super.messageEditorProvider,
  });

  @override
  String get key => kImageKey;

  /// buildThumb build the thumbnail for the embed
  @override
  Widget buildThumb(BuildContext context, String id, XFile file) {
    return Image(
      image: XFileImage(file),
    );
  }
}

/// VideoEmbedBuilder is a custom embed builder for [ImageEmbed].
class VideoEmbedBuilder extends MediaEmbedBuilder {
  VideoEmbedBuilder({
    required super.messageEditorProvider,
  });

  @override
  String get key => kVideoKey;

  /// buildThumb build the thumbnail for the embed
  @override
  Widget buildThumb(BuildContext context, String id, XFile file) {
    if (isVideoPlayerAvailable(file)) {
      final videoPlayer = messageEditorProvider.getVideoPlayerById(id);
      return AspectRatio(
        aspectRatio: videoPlayer.value.aspectRatio,
        child: VideoPlayer(videoPlayer),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      height: 120,
      color: colorScheme.secondary,
      child: Icon(
        size: 46,
        Icons.play_circle,
        color: colorScheme.onSecondary,
      ),
    );
  }
}

/// FileEmbedBuilder is a custom embed builder for [FileEmbed].
class FileEmbedBuilder extends MediaEmbedBuilder {
  FileEmbedBuilder({
    required super.messageEditorProvider,
  });

  @override
  String get key => kFileKey;

  /// buildThumb build the thumbnail for the embed
  @override
  Widget buildThumb(BuildContext context, String id, XFile file) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      height: 120,
      color: colorScheme.secondary,
      child: Icon(
        size: 46,
        Icons.insert_drive_file,
        color: colorScheme.onSecondary,
      ),
    );
  }
}
