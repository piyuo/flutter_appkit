import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:libcli/log/log.dart' as log;
import 'package:extended_image/extended_image.dart';
import 'extensions.dart';

/// webImageData get binary image data from url
Future<Uint8List?> webImageData(String url) async {
  return await getNetworkImageData(url);
}

/// webImageProvider get image provider from url
ImageProvider webImageProvider(
  String url, {
  Duration cacheMaxAge = const Duration(days: 360),
}) {
  return ExtendedNetworkImageProvider(
    url,
    cacheMaxAge: cacheMaxAge,
  );
}

class WebImage extends StatelessWidget {
  /// WebImage display image from url,display loading and failed place holder and cache image for period of time
  /// you can use SizedBox() to set width and height
  /// ```dart
  /// WebImage('https://image-url'),
  /// ```
  const WebImage(
    this.url, {
    Key? key,
    this.cacheMaxAge = const Duration(days: 360),
    this.shape,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  /// url is image url
  final String url;

  /// cacheMaxAge is image cache age, default is 360 days
  final Duration cacheMaxAge;

  /// borderRadius if non-null, the corners of this box are rounded by this [BorderRadius].
  ///
  /// Applies only to boxes with rectangular shapes; ignored if [shape] is not
  /// [BoxShape.rectangle].
  final BorderRadius? borderRadius;

  /// The shape to fill the background [color], [gradient], and [image] into and
  /// to cast as the [boxShadow].
  ///
  /// If this is [BoxShape.circle] then [borderRadius] is ignored.
  ///
  /// The [shape] cannot be interpolated; animating between two [BoxDecoration]s
  /// with different [shape]s will result in a discontinuity in the rendering.
  /// To interpolate between two shapes, consider using [ShapeDecoration] and
  /// different [ShapeBorder]s; in particular, [CircleBorder] instead of
  /// [BoxShape.circle] and [RoundedRectangleBorder] instead of
  /// [BoxShape.rectangle].
  final BoxShape? shape;

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

  @override
  Widget build(BuildContext context) {
    Widget _icon(IconData? icon) {
      return SizedBox(
          width: width,
          height: height,
          child: FittedBox(
            child: Icon(
              icon,
              color: context.themeColor(
                dark: Colors.grey.shade800,
                light: Colors.grey.shade400,
              ),
            ),
          ));
    }

    return ExtendedImage.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cache: true,
      cacheMaxAge: cacheMaxAge,
      borderRadius: borderRadius,
      shape: shape,
      border: border,
      isAntiAlias: true,
      retries: 0,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return null;

          case LoadState.completed:
            return null;

          case LoadState.failed:
            log.log('[web_image] missing $url');
            return _icon(Icons.broken_image);
        }
      },
    );
  }
}
