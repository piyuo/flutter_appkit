import 'package:flutter/material.dart';
import 'delta.dart';

/// VerticalOnPhoneLayout show column on phone screen, row on not phone screen
class VerticalOnPhoneLayout extends StatelessWidget {
  /// ```dart
  /// VerticalOnPhoneLayout(
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
  const VerticalOnPhoneLayout({
    required this.builder,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.rowMainAxisAlignment = MainAxisAlignment.center,
    super.key,
  });

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
