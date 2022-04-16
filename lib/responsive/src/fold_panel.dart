import 'package:flutter/material.dart';
import 'responsive1.dart';

/// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
/// ```dart
/// FoldPanel(
///  topLeft: Container(
///    child: const Text('top left'),
///  ),
///  bottomRight: Container(
///    child: const Text('bottom right'),
///  ),
///)
/// ```
class FoldPanel extends StatelessWidget {
  /// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
  /// ```dart
  /// FoldPanel(
  ///  topLeft: Container(
  ///    child: const Text('top left'),
  ///  ),
  ///  bottomRight: Container(
  ///    child: const Text('bottom right'),
  ///  ),
  ///)
  /// ```
  const FoldPanel({
    this.topLeft,
    required this.bottomRight,
    Key? key,
  }) : super(key: key);

  /// topLeft is widget show on top in small screen or left on big screen
  final Widget? topLeft;

  /// bottomRight is widget show on bottom in small screen or right on big screen
  final Widget bottomRight;

  @override
  Widget build(BuildContext context) => topLeft == null
      ? bottomRight
      : LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => isPhoneScreen(constraints.maxWidth)
              ? Column(children: [
                  Expanded(child: topLeft!),
                  Expanded(child: bottomRight),
                ])
              : Row(children: [
                  Expanded(child: topLeft!),
                  Expanded(child: bottomRight),
                ]));
}
