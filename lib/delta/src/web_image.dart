import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:extended_image/extended_image.dart';
import 'shimmer.dart';

/// WebImage display image from url,display loading and failed place holder and cache image for period of time on app mode
class WebImage extends StatelessWidget {
  /// WebImage display image from url,display loading and failed place holder and cache image for period of time
  /// you can use SizedBox() to set width and height
  /// ```dart
  /// WebImage(url:'https://image-url',width:100,height:100),
  /// ```
  const WebImage({
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius,
    this.border,
    this.fit = BoxFit.cover,
    this.opacity,
    Key? key,
  }) : super(key: key);

  /// url is image url, set to empty will display empty icon
  final String url;

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
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context) {
    buildPlaceHolder(bool emptyOrError) {
      if (!emptyOrError) {
        log.log('[web_image] missing $url');
      }
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Icon(
          emptyOrError ? Icons.image : Icons.broken_image,
          size: (width! / 2),
          color: Colors.grey,
        ),
      );
    }

    if (url.isEmpty) {
      return buildPlaceHolder(true);
    }

    if (kIsWeb) {
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          url,
          fit: fit,
          width: width,
          height: height,
          cacheWidth: width?.toInt(),
          cacheHeight: height?.toInt(),
          opacity: opacity,
          errorBuilder: (_, __, ___) => buildPlaceHolder(false),
        ),
      );
    }

    // app mode
    return ExtendedImage.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cache: true,
      cacheMaxAge: const Duration(days: 365),
      shape: BoxShape.rectangle,
      opacity: opacity,
      borderRadius: borderRadius,
      border: border,
      isAntiAlias: true,
      retries: 0,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return ShimmerScope(
                child: Container(
              width: width,
              height: height,
              color: Colors.grey,
            ));

          case LoadState.completed:
            return null;

          case LoadState.failed:
            return buildPlaceHolder(false);
        }
      },
    );
  }
}

/// webImageClearCache clear cache image
void webImageClearCache() async {
  if (!kIsWeb) {
    await clearDiskCachedImages();
    debugPrint('[web_image] cache cleared');
  }
}


/*

/// webImageData get binary image data from url
Future<Uint8List?> webImageData(String url) async {
  return await getNetworkImageData(url);
}

                                testing.ExampleButton(label: 'web image data', builder: () => _webImageData(context)),

  Widget _webImageData(BuildContext context) {
    const url =
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';

    return OutlinedButton(
      child: const Text('load image'),
      onPressed: () async {
        final bytes = await webImageData(url);
        if (bytes != null) {
          debugPrint('${bytes.length} loaded');
          return;
        }
        debugPrint('image not exists');
      },
    );
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


                                testing.ExampleButton(
                                    label: 'web image provider', builder: () => _webImageProvider(context)),

  Widget _webImageProvider(BuildContext context) {
    final imageProvider = webImageProvider(
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000');

    return Container(
      decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
            image: imageProvider,
          )),
    );
  }


 */