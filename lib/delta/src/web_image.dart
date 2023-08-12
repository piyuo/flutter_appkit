import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shimmer.dart';

/// WebImage display image from a url, display loading/failed place holder and cache image for period of time
class WebImage extends StatelessWidget {
  /// you can use SizedBox() to set width and height
  /// ```dart
  /// WebImage(url:'https://image-url',width:100,height:100),
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
    super.key,
  });

  /// url is image url, set to empty will display empty icon
  final String? url;

  /// image is image provider, if set, url will be ignored
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    errorBuilder() => Container(
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

    imageBuilder(imgProvider) {
      final img = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          image: DecorationImage(image: imgProvider, fit: fit),
        ),
      );

      if (opacity < 1.0) {
        return Opacity(
          opacity: opacity,
          child: img,
        );
      }
      return img;
    }

    if (url == null && image == null) {
      return errorBuilder();
    }

    if (image != null) {
      return imageBuilder(image!);
    }

    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      imageBuilder: (context, imageProvider) => imageBuilder(imageProvider),
      placeholder: (context, url) {
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
      },
      errorWidget: (context, url, error) => errorBuilder(),
    );
  }
}

/// getWebImage return ImageProvider from url
ImageProvider getWebImage(String url) {
  return CachedNetworkImageProvider(url);
}
