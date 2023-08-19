import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
import 'dart:ui' as ui;
import 'shimmer.dart';
import 'web_cache_provider.dart';

/// _WebImageProvider is web image provider
class _WebImageProvider extends WebCacheProvider {
  File? _file;

  Future<void> load(String url) async {
    _file = await getFileFromCache(url);
    if (_file == null) {
      hasError = true;
    }
    notifyListeners();
  }
}

/// WebImage display image from a url, display loading/failed place holder and cache image for period of time
/// you can use SizedBox() to set width and height
class WebImage extends StatelessWidget {
  /// ```dart
  /// WebImage('url https://image-url',width:100,height:100),
  /// ```
  const WebImage({
    this.url,
    this.image,
    this.width,
    this.height,
    this.borderRadius,
    this.border,
    this.fit = BoxFit.cover,
    this.opacity = 1.0,
    this.fadeIn = false,
    this.onImageLoaded,
    super.key,
  }) : assert(url != null || image != null);

  /// url is image url, set to empty will display empty icon
  final String? url;

  /// image is the image provider
  final ImageProvider? image;

  /// borderRadius if non-null, the corners of this box are rounded by this [BorderRadius].
  final BorderRadius? borderRadius;

  /// border to draw above the background [color], [gradient], or [image].
  ///
  /// Follows the [shape] and [borderRadius].
  ///
  /// Use [Border] objects to describe borders that do not depend on the reading
  /// direction.
  ///
  /// Use [BoxBorder] objects to describe borders that should flip their left
  /// and right edges based on whether the text is being read left-to-right or
  /// right-to-left.
  final BoxBorder? border;

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

  /// fit is how image fit box
  final BoxFit? fit;

  /// opacity is image opacity
  final double opacity;

  /// fade in image
  final bool fadeIn;

  /// onImageLoaded called when image loaded
  final void Function(ui.Image image)? onImageLoaded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    errorBuilder() {
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        child: Icon(
          Icons.question_mark,
          size: width != null ? width! / 2 : 64,
          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
      );
    }

    loadingBuilder() {
      return ShimmerScope(
          child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: colorScheme.surfaceVariant.withOpacity(0.5),
        ),
      ));
    }

    imageBuilder(Image image) {
      if (onImageLoaded != null) {
        image.image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
          onImageLoaded!(info.image);
        }));
      }

      Widget child = image;
      if (borderRadius != null) {
        child = ClipRRect(
          borderRadius: borderRadius!,
          child: child,
        );
      }

      if (border != null) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
          ),
          child: child,
        );
      }

      return SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }

    if (image != null) {
      // no cache
      return imageBuilder(
        Image(
          image: image!,
          fit: fit,
          opacity: AlwaysStoppedAnimation(opacity),
          errorBuilder: (_, __, ___) => errorBuilder(),
        ),
      );
    }

    if (isCacheAllowed) {
      return ChangeNotifierProvider<_WebImageProvider>(create: (_) {
        final webImageProvider = _WebImageProvider();
        Future.microtask(() => webImageProvider.load(url!));
        return webImageProvider;
      }, child: Consumer<_WebImageProvider>(builder: (context, webImageProvider, _) {
        cachedBuilder() {
          if (webImageProvider._file == null) {
            return loadingBuilder();
          }
          // show
          final image = Image.file(
            webImageProvider._file!,
            fit: fit,
            opacity: AlwaysStoppedAnimation(opacity),
            errorBuilder: (_, __, ___) => errorBuilder(),
          );
          return imageBuilder(image);
        }

        // error
        if (webImageProvider.hasError) {
          return errorBuilder();
        }

        // loading
        return fadeIn
            ? AnimatedOpacity(
                opacity: webImageProvider._file == null ? .3 : 1,
                duration: const Duration(milliseconds: 500),
                child: cachedBuilder(),
              )
            : cachedBuilder();
      }));
    }

    // no cache
    return imageBuilder(Image.network(
      url!,
      fit: fit,
      opacity: AlwaysStoppedAnimation(opacity),
      //loadingBuilder: (_, __, ___) => loadingBuilder(),
      errorBuilder: (_, __, ___) => errorBuilder(),
    ));
  }
}
