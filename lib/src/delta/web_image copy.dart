import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/log.dart' as log;
import 'package:extended_image/extended_image.dart';

class WebImageProvider with ChangeNotifier {
  bool _error = false;
  String _url = '';

  void setError(String url, bool error) {
    _error = error;
    _url = url;
  }

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
    this.cacheMaxAge = const Duration(days: 365),
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 25,
  }) : super(key: key);

  final String url;

  final Duration cacheMaxAge;

  final Color? borderColor;

  final double borderWidth;

  final double borderRadius;

  Widget _icon(
    BuildContext context,
    IconData? icon,
    Border? border,
    BorderRadius radius,
  ) {
    return Container(color: Colors.red);
    return Container(
      decoration: BoxDecoration(
//        border: border,
        //       borderRadius: radius,
        color: context.themeColor(
          dark: Colors.grey[850]!,
          light: Colors.grey[200]!,
        ),
      ),
      child: FittedBox(
          child: Icon(
        icon,
        color: context.themeColor(
          dark: Colors.grey[800]!,
          light: Colors.grey[400]!,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WebImageProvider>(
        create: (context) => WebImageProvider(),
        child: Consumer<WebImageProvider>(builder: (context, provide, child) {
          var border = borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null;
          var radius = BorderRadius.all(Radius.circular(borderRadius));

          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: provide.isError(url)
                ? _icon(context, Icons.broken_image, border, radius)
                : ExtendedImage.network(
                    url,
                    fit: BoxFit.cover,
                    cache: true,
                    cacheMaxAge: cacheMaxAge,
                    border: border,
                    borderRadius: radius,
                    isAntiAlias: true,
                    retries: 0,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          log.debug('[web-image] download $url');
                          return _icon(context, Icons.image, border, radius);

                        case LoadState.completed:
                          return null;

                        case LoadState.failed:
                          log.log('[web-image] missing $url');
                          provide.setError(url, true);
                          return _icon(context, Icons.broken_image, border, radius);
                      }
                    },
                  ),
          );
        }));
  }
}
