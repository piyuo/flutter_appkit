import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:provider/provider.dart';

class SlideshowProvider with ChangeNotifier {
  int current = 0;
  final CarouselController controller = CarouselController();

  void onPageChanged(int index) {
    current = index;
    notifyListeners();
  }
}

/// Slideshow must set height and imageWidth to make image show perfectly
class Slideshow extends StatelessWidget {
  /// Slideshow must set height and imageWidth to make image show perfectly
  ///
  ///     Slideshow(
  ///    urls: [
  ///      'https://image',
  ///    ],
  ///  )
  ///
  Slideshow({
    required this.urls,
    this.imageWidth = 300,
    this.height = 300,
  });

  final double imageWidth;

  final double height;

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SlideshowProvider(),
      child: Consumer<SlideshowProvider>(builder: (_, _model, __) {
        return Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) => CarouselSlider(
                carouselController: _model.controller,
                options: CarouselOptions(
                  viewportFraction: delta.isPhoneLayout(constraints.maxWidth) ? 1 : imageWidth / constraints.maxWidth,
                  height: height,
                  autoPlay: true,
                  onPageChanged: (index, _) => _model.onPageChanged(index),
                ),
                items: urls
                    .map((url) => Padding(
                          padding: delta.isPhoneLayout(constraints.maxWidth)
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(horizontal: 8),
                          child: delta.WebImage(
                            url,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: urls.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _model.controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.themeColor(
                        dark: Color.fromRGBO(234, 234, 237, _model.current == entry.key ? 0.9 : 0.4),
                        light: Color.fromRGBO(38, 38, 40, _model.current == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
