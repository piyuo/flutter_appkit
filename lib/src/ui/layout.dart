import 'package:flutter/material.dart';

///  _isPortraitLayout return true if window width should use portrait layout
bool _isPortraitLayout(double windowWidth) {
  return windowWidth < 600 ? true : false;
}

///  Layout can help to choose desktop or mobile layout
class Layout extends StatelessWidget {
  Layout({
    required this.landscape,
    required this.portrait,
  });

  final Widget Function(BuildContext) landscape;

  final Widget Function(BuildContext) portrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (_isPortraitLayout(constraints.maxWidth)) {
        return portrait(context);
      }
      return landscape(context);
    });
  }
}
