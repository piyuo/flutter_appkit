import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'share.dart';
import 'web_image.dart';
import 'web_video.dart';
import 'qr_image.dart';
import 'page_route.dart';
import 'reponsive_bar_view.dart';

/// kPreviewHeroTag is the hero tag for preview
int kPreviewHeroIndex = 0;

class _PreviewProvider {
  _PreviewProvider(this.heroIndex);
  int heroIndex;
}

/// Preview is widget allow click to enlarge
class Preview extends StatelessWidget {
  const Preview({
    required this.builder,
    required this.previewBuilder,
    this.onShare,
    this.useHeroEffect = true,
    this.interactive = true,
    super.key,
  });

  /// builder is the widget builder
  final utils.WidgetBuilder builder;

  /// previewBuilder is the widget builder for preview
  final utils.WidgetBuilder previewBuilder;

  /// onShare is the share button callback
  final VoidCallback? onShare;

  /// useHeroEffect is true if use hero effect
  final bool useHeroEffect;

  /// interactive is true if allow interactive
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return Provider<_PreviewProvider>(
        create: (context) => _PreviewProvider(kPreviewHeroIndex++),
        child: Consumer<_PreviewProvider>(builder: (context, previewProvider, _) {
          final heroTag = previewProvider.heroIndex.toString();
          return InkWell(
            child: useHeroEffect
                ? Hero(
                    tag: heroTag,
                    child: builder(),
                  )
                : builder(),
            onTapDown: (_) {
              preview(
                context,
                interactive: interactive,
                heroTag: heroTag,
                onShare: onShare,
                child: previewBuilder(),
              );
            },
          );
        }));
  }
}

/// preview image in preview dialog
/// ```dart
/// preview(
///   context,
///   child: delta.WebImage(context, url: 'https://www.sample.com/img/bd_logo1.png'),
/// )
/// ```
void preview<T>(
  BuildContext context, {
  required Widget child,
  required String heroTag,
  bool interactive = true,
  VoidCallback? onShare,
}) {
  Navigator.push<T>(context, FadeRouteBuilder(
    () {
      final colorScheme = Theme.of(context).colorScheme;
/*
      return Scaffold(
        body: BarView(
          barBuilder: () => bar(context, floating: true, backgroundColor: Colors.blue.withOpacity(.1), pinned: false),
          slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Hero(
                    tag: heroTag,
                    child: interactive
                        ? InteractiveViewer(
                            constrained: true,
                            panEnabled: true, // Set it to false to prevent panning.
                            panAxis: PanAxis.aligned,
                            minScale: 0.5,
                            maxScale: 3.5,
                            child: Container(color: Colors.red) //child,
                            )
                        : child))
          ],
        ),
      );
*/
      return Container(
          color: colorScheme.background,
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                    tag: heroTag,
                    child: interactive
                        ? InteractiveViewer(
                            constrained: true,
                            panEnabled: true, // Set it to false to prevent panning.
                            panAxis: PanAxis.aligned,
                            minScale: 0.5,
                            maxScale: 3.5,
                            child: child,
                          )
                        : child),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ResponsiveAppBar(
                    backgroundColor: Colors.transparent,
                    actions: [
                      if (onShare != null)
                        IconButton(
                          icon: const Icon(Icons.ios_share),
                          onPressed: () => onShare(),
                        ),
                    ],
                  )),
            ],
          ));
    },
  ));
}

/// PreviewImage allow image to enlarge
class PreviewImage extends StatelessWidget {
  const PreviewImage(
    this.url, {
    this.borderRadius,
    super.key,
  });

  /// url is the image url
  final String url;

  /// borderRadius is the image border radius
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Preview(
      builder: () => WebImage(
        url: url,
        borderRadius: borderRadius,
      ),
      previewBuilder: () => WebImage(
        url: url,
        borderRadius: borderRadius,
        fit: null,
      ),
      onShare: () => shareByCacheOrUrl(url),
    );
  }
}

/// PreviewVideo allow image to enlarge
class PreviewVideo extends StatelessWidget {
  const PreviewVideo(
    this.url, {
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  /// url is the image url
  final String url;

  /// width is the video width
  final double? width;

  /// height is the video height
  final double? height;

  /// borderRadius is the video border radius
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Preview(
      useHeroEffect: false,
      interactive: false,
      onShare: () => shareByCacheOrUrl(url),
      builder: () => WebVideo(
        url: url,
        showControls: false,
        borderRadius: borderRadius,
        width: width,
        height: height,
      ),
      previewBuilder: () => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Center(
            child: WebVideo(
              url: url,
            ),
          ),
        ),
      ),
    );
  }
}

/// PreviewQrImage allow qrcode to enlarge
class PreviewQrImage extends StatelessWidget {
  const PreviewQrImage(
    this.data, {
    this.size,
    super.key,
  });

  /// data is the qrcode data
  final String data;

  /// size is the qrcode size
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Preview(
        builder: () => QrImage(
              data,
            ),
        previewBuilder: () => Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: QrImage(data),
              ),
            ));
  }
}
