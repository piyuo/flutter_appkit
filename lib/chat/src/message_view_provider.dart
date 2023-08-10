import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:chewie/chewie.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:video_player/video_player.dart';

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

  /// reset all data, let user start from scratch
  void reset() {
    for (final entry in _videoPlayers.entries) {
      entry.value.videoPlayerController.dispose();
      entry.value.dispose();
    }
    _videoPlayers.clear();
  }

  @override
  void dispose() {
    reset();
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
        }
      }
    }
    notifyListeners();
  }

  /// getVideoPlayerById return video player by id
  ChewieController? getVideoPlayerById(String id) => _videoPlayers[id];
}
