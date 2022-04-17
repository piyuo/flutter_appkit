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
    this.columnPadding = EdgeInsets.zero,
    this.rowPadding = EdgeInsets.zero,
  }) : super(key: key);

  /// children show column in small screen, row on big screen
  final List<Widget> children;

  /// columnPadding is the padding of column
  final EdgeInsets columnPadding;

  /// rowPadding is the padding of row
  final EdgeInsets rowPadding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => isPhoneScreen(constraints.maxWidth)
          ? Padding(
              padding: columnPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ))
          : Padding(
              padding: rowPadding,
              child: Row(
                children: children.map((child) => Expanded(child: child)).toList(),
              )));
}
