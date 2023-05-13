import 'package:flutter/material.dart';
import 'delta.dart';

/// TurnToPhoneLayout show column on phone screen, row on not phone screen
class TurnToPhoneLayout extends StatelessWidget {
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
  const TurnToPhoneLayout({
    required this.builder,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.rowMainAxisAlignment = MainAxisAlignment.center,
    Key? key,
  }) : super(key: key);

  /// children show column in small screen, row on big screen
  final List<Widget> Function(bool isColumn) builder;

  /// columnCrossAxisAlignment set crossAxisAlignment in column
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// rowMainAxisAlignment set mainAxisAlignment in row
  final MainAxisAlignment rowMainAxisAlignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => isPhoneScreen(constraints.maxWidth)
          ? Column(
              crossAxisAlignment: columnCrossAxisAlignment,
              children: builder(true),
            )
          : Row(
              mainAxisAlignment: rowMainAxisAlignment,
              children: builder(false),
            ));
}
