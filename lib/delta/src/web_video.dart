import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_io/io.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'shimmer.dart';

/// _WebVideoProvider provide video controller to WebVideo
class _WebVideoProvider with ChangeNotifier {
  /// _videoPlayers keep track of all videoPlayers
  ChewieController? _chewieController;

  /// isReady return true if video is ready to play
  bool get isReady => _chewieController != null;

  BaseCacheManager getCacheManager() => CacheManager(
        Config(
          'videoCache',
          stalePeriod: const Duration(days: 360),
          maxNrOfCacheObjects: 1000,
        ),
      );

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController!.videoPlayerController.dispose();
      _chewieController!.dispose();
    }
    super.dispose();
  }

  /// load video from url and support cache
  /// video player may support cache in the future, right now we use cache manager to cache video
  Future<void> load(String? url, String? path) async {
    VideoPlayerController? videoController;

    if (kIsWeb) {
      if (url != null) {
        videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      }
    } else if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      // download whole video to cache then play
      // video player may support stream and cache in the future
      final cacheManager = getCacheManager();
      if (url != null) {
        FileInfo? fileInfo = await cacheManager.getFileFromCache(url);
        fileInfo ??= await cacheManager.downloadFile(url);
        videoController = VideoPlayerController.file(fileInfo.file);
      } else if (path != null) {
        videoController = VideoPlayerController.file(File(path));
      }
    }

    if (videoController == null) {
      debugPrint('video player by ${url != null ? 'url' : 'path'} is not support on this platform');
      return;
    }

    await videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoController,
      //autoPlay: true,
      looping: true,
    );
    notifyListeners();
  }
}

/// WebVideo display video from a url, display loading/failed place holder and cache video for period of time
class WebVideo extends StatelessWidget {
  /// you can use SizedBox() to set width and height
  /// ```dart
  /// WebVideo(url:'https://image-url',width:100,height:100),
  /// ```
  const WebVideo({
    this.url,
    this.path,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  /// url is video url
  final String? url;

  /// path is video path
  final String? path;

  /// width if non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  ///
  /// It is strongly recommended that either both the [width] and the [height]
  /// be specified, or that the widget be placed in a context that sets tight
  /// layout constraints, so that the image does not change size as it loads.
  /// Consider using [fit] to adapt the image's rendering to fit the given width
  /// and height if the exact image dimensions are not known in advance.
  final double? width;

  /// height if non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  ///
  /// It is strongly recommended that either both the [width] and the [height]
  /// be specified, or that the widget be placed in a context that sets tight
  /// layout constraints, so that the image does not change size as it loads.
  /// Consider using [fit] to adapt the image's rendering to fit the given width
  /// and height if the exact image dimensions are not known in advance.
  final double? height;

  /// borderRadius if non-null, the corners of this box are rounded by this [BorderRadius].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    assert(url != null || path != null, 'url or path must not be null');
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<_WebVideoProvider>(
        create: (_) => _WebVideoProvider()..load(url, path),
        child: Consumer<_WebVideoProvider>(builder: (context, webVideoProvider, _) {
          if (UniversalPlatform.isDesktop) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              child: Align(
                  child: IconButton(
                      onPressed: url != null ? () => utils.openUrl(url!) : null,
                      icon: Icon(
                        size: width != null ? width! / 2 : 64,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        Icons.play_circle,
                      ))),
            );
          }

          if (webVideoProvider.isReady) {
            final video = ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width ?? double.infinity,
                  maxHeight: height ?? double.infinity,
                ),
                child: AspectRatio(
                    aspectRatio: webVideoProvider._chewieController!.videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: webVideoProvider._chewieController!,
                    )));
            if (borderRadius != null) {
              return ClipRRect(
                borderRadius: borderRadius,
                child: video,
              );
            }
            return video;
          }

          return ShimmerScope(
              child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: colorScheme.surfaceVariant.withOpacity(0.5),
            ),
          ));
        }));
  }
}
