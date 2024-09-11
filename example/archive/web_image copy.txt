import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:extended_image/extended_image.dart';
import 'shimmer.dart';

/// _kDefaultCachePeriod is default cache period
const _kDefaultCachePeriod = Duration(days: 365);

class WebImage extends StatefulWidget {
  /// WebImage display image from url,display loading and failed place holder and cache image for period of time
  /// you can use SizedBox() to set width and height
  /// ```dart
  /// WebImage(url:'https://image-url',width:100,height:100),
  /// ```
  const WebImage({
    required this.url,
    this.width,
    this.height,
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
  WebImageState createState() => WebImageState();
}

class WebImageState extends State<WebImage> {
  /// hasError is image load error
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    loadingBuilder() {
      return ShimmerScope(
          child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey,
      ));
    }

    placeHolderBuilder(bool emptyOrError) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Icon(
          emptyOrError ? Icons.photo_camera : Icons.question_mark,
          size: widget.width != null ? widget.width! / 2 : 64,
          color: Colors.grey,
        ),
      );
    }

    errorBuilder(e, s) {
      Future.microtask(() {
        setState(() {
          log.log('[web_image] missing ${widget.url}');
          if (e != null && s != null) log.error(e, s);
          hasError = true;
        });
      });
      return placeHolderBuilder(false);
    }

    if (hasError) {
      return placeHolderBuilder(false);
    }

    if (widget.url.isEmpty) {
      return placeHolderBuilder(true);
    }

    if (kIsWeb) {
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          widget.url,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          opacity: widget.opacity,
          loadingBuilder: (_, __, ___) => loadingBuilder(),
          errorBuilder: (_, e, s) => errorBuilder(e, s),
        ),
      );
    }

    // app mode
    return ExtendedImage.network(
      widget.url,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      cache: true,
      cacheMaxAge: _kDefaultCachePeriod,
      shape: BoxShape.rectangle,
      opacity: widget.opacity,
      borderRadius: widget.borderRadius,
      border: widget.border,
      isAntiAlias: true,
      retries: 0,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return loadingBuilder();
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return errorBuilder(null, null);
        }
      },
    );
  }
}

/// webImageClearCache clear cache image
void webImageClearCache() async {
  if (!kIsWeb) {
    await clearDiskCachedImages(duration: _kDefaultCachePeriod);
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