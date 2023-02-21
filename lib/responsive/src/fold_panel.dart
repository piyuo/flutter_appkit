import 'package:flutter/material.dart';
import 'responsive.dart';

/// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
/// ```dart
/// FoldPanel(
///  builder: (isColumn) => [
///      Expanded(
///          child: Container(
///        color: Colors.red,
///        child: Text('$isColumn'),
///      )),
///      Expanded(
///          child: Container(
///        color: Colors.blue,
///        child: Text('$isColumn'),
///      )),
///    ])
/// ```
class FoldPanel extends StatelessWidget {
  /// FoldPanel show two widget on top/bottom in small screen, left/right on big screen
  /// ```dart
  /// FoldPanel(
  ///  builder: (isColumn) => [
  ///      Expanded(
  ///          child: Container(
  ///        color: Colors.red,
  ///        child: Text('$isColumn'),
  ///      )),
  ///      Expanded(
  ///          child: Container(
  ///        color: Colors.blue,
  ///        child: Text('$isColumn'),
  ///      )),
  ///    ])
  /// ```
  const FoldPanel({
    required this.builder,
    Key? key,
  }) : super(key: key);

  /// children show column in small screen, row on big screen
  final List<Widget> Function(bool isColumn) builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => isPhoneScreen(constraints.maxWidth)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: builder(true),
            )
          : Row(
              children: builder(false),
            ));
}
