import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:libcli/delta.dart' as delta;
import 'package:libcli/theme.dart';
import 'package:provider/provider.dart';

class SlideshowProvider with ChangeNotifier {
  int current = 0;
  final CarouselController controller = CarouselController();

  void onPageChanged(int index) {
    current = index;
    notifyListeners();
  }
}

class Slideshow extends StatelessWidget {
  double _slideshowHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 38.2 / 100;
  }

  final List<String> imgList = [
    'asset/images/0.webp',
    'asset/images/1.webp',
    'asset/images/2.webp',
    'asset/images/3.webp',
    'asset/images/4.webp',
  ];

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
                  viewportFraction: delta.isMobileLayout(constraints.maxWidth) ? 1 : 600 / constraints.maxWidth,
                  height: _slideshowHeight(context),
                  autoPlay: true,
                  onPageChanged: (index, _) => _model.onPageChanged(index),
                ),
                items: imgList
                    .map((i) => Padding(
                          padding: delta.isMobileLayout(constraints.maxWidth)
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(horizontal: 8),
                          child: Image(
                            image: AssetImage(i),
                            width: delta.isDesktopLayout(constraints.maxWidth) ? 1024 : constraints.maxWidth,
                            fit: BoxFit.cover,
                          ),
                          /*child: Image.network(
                                    imgList[i],
                                    width: constraints.maxWidth,
                                    fit: BoxFit.cover,
                                  ),*/
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _model.controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.themeColor(ThemeColor(
                        dark: Color.fromRGBO(234, 234, 237, _model.current == entry.key ? 0.9 : 0.4),
                        light: Color.fromRGBO(38, 38, 40, _model.current == entry.key ? 0.9 : 0.4),
                      )),
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
