import 'package:flutter/material.dart';

///  isMobileLayout return true if window width should use mobile layout
bool isMobileLayout(double windowWidth) {
  return windowWidth < 600 ? true : false;
}

///  Layout can help to choose desktop or mobile layout
class Layout extends StatelessWidget {
  Layout({
    required this.desktop,
    required this.mobile,
  });

  final Widget Function(BuildContext) desktop;

  final Widget Function(BuildContext) mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isMobileLayout(constraints.maxWidth)) {
        return mobile(context);
      }
      return desktop(context);
    });
  }
}
