import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:extended_image/extended_image.dart';
import 'package:shimmer/shimmer.dart';
import 'extensions.dart';
import 'package:flutter/foundation.dart';

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

/// _WebImageController is a controller for web image
class _WebImageController with ChangeNotifier {
  bool _error = false;
  String _url = '';

  /// setError to avoid load image again and again
  void setError(String url, bool error) {
    _error = error;
    _url = url;
    Future.microtask(() => notifyListeners());
  }

  /// isError return true if failed to load image
  bool isError(String url) {
    return _url == url && _error;
  }
}

/// WebImage display image from url,display loading and failed place holder and cache image for period of time
/// you can use SizedBox() to set width and height
class WebImage extends StatelessWidget {
  const WebImage(
    this.url, {
    Key? key,
    this.cacheMaxAge = const Duration(days: 360),
    this.borderRadius = 25,
  }) : super(key: key);

  /// url is image url
  final String url;

  /// cacheMaxAge is image cache age, default is 360 days
  final Duration cacheMaxAge;

  final double borderRadius;

  Widget _icon(
    BuildContext context,
    IconData? icon,
  ) {
    return FittedBox(
        child: Icon(
      icon,
      color: context.themeColor(
        dark: Colors.grey[800]!,
        light: Colors.grey[400]!,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_WebImageController>(
        create: (context) => _WebImageController(),
        child: Consumer<_WebImageController>(builder: (context, provide, child) {
          var radius = BorderRadius.all(Radius.circular(borderRadius));
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: provide.isError(url)
                ? _icon(context, Icons.broken_image)
                : ExtendedImage.network(
                    url,
                    fit: BoxFit.cover,
                    cache: true,
                    cacheMaxAge: cacheMaxAge,
                    borderRadius: radius,
                    isAntiAlias: true,
                    retries: 0,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: _icon(context, Icons.image),
                          );

                        case LoadState.completed:
                          return null;

                        case LoadState.failed:
                          log.log('[web-image] missing $url');
                          provide.setError(url, true);
                          return _icon(context, Icons.broken_image);
                      }
                    },
                  ),
          );
        }));
  }
}
