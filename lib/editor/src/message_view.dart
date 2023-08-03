import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:chewie/chewie.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:video_player/video_player.dart';

/// _kBorderRadius is the border radius for embed
const _kBorderRadius = BorderRadius.all(Radius.circular(12));

/// UrlBuilder return the url of the image base on word type and id
typedef UrlBuilder = String Function(pb.Word_WordType type, String id);

/// MessageViewProvider provide video controller to MessageView
class MessageViewProvider with ChangeNotifier {
  MessageViewProvider({
    required this.urlBuilder,
  });

  /// _videoPlayers keep track of all videoPlayers
  final Map<String, ChewieController> _videoPlayers = {};

  /// imageUrlBuilder return the url of the image base on given image id
  final UrlBuilder urlBuilder;

  /// clear clear all data, let user start from scratch
  void clear() {
    for (final entry in _videoPlayers.entries) {
      entry.value.videoPlayerController.dispose();
      entry.value.dispose();
    }
    _videoPlayers.clear();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  /// scanWords for video
  Future<void> scanVideo(List<pb.Word> words) async {
    for (final word in words) {
      if (word.type == pb.Word_WordType.WORD_TYPE_VIDEO && !UniversalPlatform.isDesktop) {
        final id = word.value;
        if (!_videoPlayers.containsKey(id)) {
          String url = urlBuilder(word.type, id);
          final controller = VideoPlayerController.networkUrl(Uri.parse(url));
          //const double volume = kIsWeb ? 0.0 : 1.0;
          //await controller.setVolume(volume);
          await controller.initialize();
          _videoPlayers[id] = ChewieController(
            videoPlayerController: controller,
            //autoPlay: true,
            looping: true,
          );
          /*
          await controller.setLooping(true);
          await controller.play();
          */
        }
      }
    }
    notifyListeners();
  }

  /// getVideoPlayerById return video player by id
  ChewieController? getVideoPlayerById(String id) => _videoPlayers[id];
}

class MessageView extends StatelessWidget {
  const MessageView({
    required this.words,
    required this.messageViewProvider,
    super.key,
  });

  /// words is a list of words that will be display
  final List<pb.Word> words;

  final MessageViewProvider messageViewProvider;

  @override
  Widget build(BuildContext context) {
    buildEmbed(Widget child) {
      return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
                maxHeight: 480,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: child,
              )));
    }

    buildPreview(Widget child) {
      return buildEmbed(Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: _kBorderRadius),
        child: Center(child: child),
      ));
    }

    return Wrap(
      children: words.map((word) {
        switch (word.type) {
          case pb.Word_WordType.WORD_TYPE_TEXT:
            return Text(word.value);
          case pb.Word_WordType.WORD_TYPE_IMAGE:
            return buildEmbed(delta.WebImage(
              url: messageViewProvider.urlBuilder(word.type, word.value),
              borderRadius: _kBorderRadius,
            ));
          case pb.Word_WordType.WORD_TYPE_VIDEO:
            if (UniversalPlatform.isDesktop) {
              return buildPreview(IconButton(
                onPressed: () {
                  utils.openUrl(messageViewProvider.urlBuilder(word.type, word.value));
                },
                icon: const Icon(
                  size: 46,
                  Icons.play_circle,
                ),
              ));
            }

            final videoPlayer = messageViewProvider.getVideoPlayerById(word.value);
            if (videoPlayer == null) {
              //video player not load yet
              return buildPreview(const Icon(
                size: 46,
                Icons.play_circle,
              ));
            }

            return buildEmbed(AspectRatio(
                aspectRatio: videoPlayer.videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: videoPlayer,
                )));

          default:
        }
        return const SizedBox();
      }).toList(),
    );
  }
}
