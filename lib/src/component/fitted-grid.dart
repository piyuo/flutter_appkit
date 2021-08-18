import 'package:flutter/material.dart';

/// Fitted like inline block but it can fit grid
class Fitted extends StatelessWidget {
  Fitted({
    this.height = 120,
    this.width = 340,
    this.child,
  });

  final double height;

  final double width;

  final Widget? child;

  Widget build(BuildContext context) {
    assert(child != null);
    return child!;
  }
}

/// FittedGrid can put fitted widget inside and make sure fitted fit to the grid
class FittedGrid extends StatelessWidget {
  FittedGrid({
    this.children = const <Widget>[],
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Wrap(
            children: children.map<Widget>((child) {
              if (child is Fitted) {
                var fitted = child;
                var count = constraints.maxWidth ~/ fitted.width;
                var extraSpace = constraints.maxWidth % fitted.width / count;
                return SizedBox(
                  width: fitted.width + extraSpace,
                  height: fitted.height,
                  child: fitted.child,
                );
              }
              return child;
            }).toList(),
          );
        }),
      ),
    );
  }
}
