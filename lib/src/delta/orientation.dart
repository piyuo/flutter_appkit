import 'package:flutter/material.dart';
import 'layout.dart';

///  Orientation can help to choose portrait or landscape mode
class Orientation extends StatelessWidget {
  Orientation({
    required this.landscape,
    required this.portrait,
  });

  final Widget Function(BuildContext) landscape;

  final Widget Function(BuildContext) portrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isMobileLayout(constraints.maxWidth)) {
        return portrait(context);
      }
      return landscape(context);
    });
  }
}
