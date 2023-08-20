import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_io/io.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'shimmer.dart';
import 'web_cache_provider.dart';

/// VideoLoadedCallback is called when video is loaded
typedef VideoLoadedCallback = void Function(VideoPlayerValue video);

/// isVideoPlayerAllowed return true if video player is allowed on this platform
bool isVideoPlayerAllowed() => kIsWeb || UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

/// _WebVideoProvider provide video controller to WebVideo
class _WebVideoProvider extends WebCacheProvider {
  /// _videoPlayerController play video
  VideoPlayerController? _videoPlayerController;

  /// _chewieController display controls for video
  ChewieController? _chewieController;

  /// isReady return true if video is ready to play
  bool get isReady => _videoPlayerController != null;

  @override
  void dispose() {
    super.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null;
    }
  }

  /// _createVideoPlayerController create video player controller from url or path
  Future<VideoPlayerController> _createVideoPlayerController(String? url, String? path) async {
    if (path != null) {
      if (kIsWeb) {
        return VideoPlayerController.networkUrl(Uri.parse(path));
      }
      return VideoPlayerController.file(File(path));
    }

    if (isCacheAllowed) {
      // download whole video to cache then play
      // video player may support stream and cache in the future
      final file = await getFileFromCache(url!);
      if (file != null) {
        return VideoPlayerController.file(file);
      }
    }
    return VideoPlayerController.networkUrl(Uri.parse(url!));
  }

  /// load video from url and support cache
  /// video player may support cache in the future, right now we use cache manager to cache video
  Future<void> load(String? url, String? path, bool showControls, VideoLoadedCallback? callback) async {
    _videoPlayerController = await _createVideoPlayerController(url, path);
    try {
      await _videoPlayerController!.initialize();
    } catch (e) {
      hasError = true;
    }

    if (disposed) {
      return;
    }

    if (callback != null) {
      callback(_videoPlayerController!.value);
    }

    if (showControls) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        showOptions: false,
      );
    }
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
    this.showControls = true,
    this.onVideoLoaded,
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

  /// showControls if true, show video controls
  final bool showControls;

  /// onVideoLoaded called when video loaded
  final VideoLoadedCallback? onVideoLoaded;

  @override
  Widget build(BuildContext context) {
    assert(url != null || path != null, 'url or path must not be null');
    final colorScheme = Theme.of(context).colorScheme;
    buildIcon(Widget child) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        child: Align(child: child),
      );
    }

    if (!isVideoPlayerAllowed()) {
      // no video player support
      return buildIcon(IconButton(
          onPressed: url != null ? () => utils.openUrl(url!) : null,
          icon: Icon(
            size: width != null ? width! / 3 : 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            Icons.play_circle,
          )));
    }

    return ChangeNotifierProvider<_WebVideoProvider>(
        create: (_) => _WebVideoProvider()..load(url, path, showControls, onVideoLoaded),
        child: Consumer<_WebVideoProvider>(builder: (context, webVideoProvider, _) {
          // show error
          if (webVideoProvider.hasError ||
              (webVideoProvider._videoPlayerController != null &&
                  webVideoProvider._videoPlayerController!.value.hasError)) {
            return buildIcon(Icon(
              size: width != null ? width! / 3 : 64,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              Icons.videocam_off,
            ));
          }

          // show video
          if (webVideoProvider.isReady) {
            final video = ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width ?? double.infinity,
                  maxHeight: height ?? double.infinity,
                ),
                child: AspectRatio(
                  aspectRatio: webVideoProvider._videoPlayerController!.value.aspectRatio,
                  child: webVideoProvider._chewieController != null
                      ? Chewie(
                          controller: webVideoProvider._chewieController!,
                        )
                      : VideoPlayer(webVideoProvider._videoPlayerController!),
                ));
            if (borderRadius != null) {
              return ClipRRect(
                borderRadius: borderRadius!,
                child: video,
              );
            }
            return video;
          }

          // show loading
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
