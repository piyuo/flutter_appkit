import 'package:flutter/material.dart';
import 'responsive1.dart';

/// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
/// ```dart
/// FoldPanel(children: [
/// Container(
///   color: Colors.red,
///   child: const Text('top left'),
/// ),
/// Container(
///   color: Colors.blue,
///   child: const Text('bottom right'),
/// ]);
///)
/// ```
class FoldPanel extends StatelessWidget {
  /// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
  /// ```dart
  /// FoldPanel(children: [
  /// Container(
  ///   color: Colors.red,
  ///   child: const Text('top left'),
  /// ),
  /// Container(
  ///   color: Colors.blue,
  ///   child: const Text('bottom right'),
  /// ]);
  ///)
  /// ```
  const FoldPanel({
    required this.children,
    Key? key,
  }) : super(key: key);

  /// children show column in small screen, row on big screen
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => isPhoneScreen(constraints.maxWidth)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Row(
              children: children.map((child) => Expanded(child: child)).toList(),
            ));
}
