import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/log.dart' as log;
import 'package:extended_image/extended_image.dart';

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

  Widget _image(
    BuildContext context,
    IconData? icon,
    Border? border,
    BorderRadius radius,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: radius,
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
          light: Colors.grey[300]!,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var border = borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null;
    var radius = BorderRadius.all(Radius.circular(borderRadius));
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ExtendedImage.network(
        url,
        fit: BoxFit.cover,
        cache: true,
        cacheMaxAge: cacheMaxAge,
        border: border,
        borderRadius: radius,
        isAntiAlias: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              log.debug('[web-image] download $url');
              return _image(context, delta.CustomIcons.image, border, radius);

            case LoadState.completed:
              return null;

            case LoadState.failed:
              log.log('[web-image] missing $url');
              return _image(context, delta.CustomIcons.brokenImage, border, radius);
          }
        },
      ),
    );
  }
}
