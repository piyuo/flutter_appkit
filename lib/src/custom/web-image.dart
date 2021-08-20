import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:extended_image/extended_image.dart';

/// WebImage display image from url,display loading and failed place holder and cache image for period of time
class WebImage extends StatelessWidget {
  WebImage({
    required this.url,
    required this.width,
    required this.height,
    this.cacheMaxAge = const Duration(days: 365),
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 25,
  });

  final String url;

  final double width;

  final double height;

  final Duration cacheMaxAge;

  final Color? borderColor;

  final double borderWidth;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var border = borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null;
    var radius = BorderRadius.all(Radius.circular(borderRadius));
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ExtendedImage.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        cache: true,
        cacheMaxAge: cacheMaxAge,
        border: border,
        borderRadius: radius,
        isAntiAlias: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              print('loading');
              return Container(color: Colors.grey);

            case LoadState.completed:
              print('complete');
              return null;

            case LoadState.failed:
              print('failed');
              return Container(
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: radius,
                    color: Colors.grey,
                  ),
                  child: Icon(
                    delta.CustomIcons.brokenImage,
                    size: 128,
                    color: Colors.white,
                  ));
          }
        },
      ),
    );
  }
}
