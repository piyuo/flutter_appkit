import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showPopup show popup dialog
/// ```dart
/// final result = await showPopup(
///   context,
/// titleBuilder: () => Positioned(
///     left: 15,
///     top: 10,
///     child: Text('Your Order', style: TextStyle(fontSize: 24, color: context.invertedColor))),
///   builder: (context) => ListView(
///      controller: scrollController,
///      children: const [
///        Text('sheetContent'),
///      ],
///   ))
/// ```
Future<T?> showPopup<T>(
  BuildContext context, {
  required Widget Function() builder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Decoration? decoration,
  double maxWidth = 600,
  double heightFactor = 0.7,
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(16)),
}) async {
  Widget build() => FractionallySizedBox(
      heightFactor: heightFactor,
      child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: decoration ??
                  BoxDecoration(
                    color: context.themeColor(
                      light: Colors.white,
                      dark: Colors.grey.shade800,
                    ),
                    borderRadius: borderRadius,
                  ),
              child: buildDialogContent(
                context,
                builder: builder,
                topBuilder: topBuilder,
                bottomBuilder: bottomBuilder,
                decoration: decoration,
                padding: padding,
              ),
            ),
          )));

  return await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(scale: curve, child: build());
    },
    pageBuilder: (context, a1, a2) => build(),
  );
}

/// buildDialogContent return a widget that will be shown in the dialog or bottom of the sheet
Widget buildDialogContent<T>(
  BuildContext context, {
  required Widget Function() builder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Decoration? decoration,
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
}) {
  return Column(
    children: [
      topBuilder != null
          ? topBuilder()
          : Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                iconSize: 32,
                color: Colors.grey,
                icon: const Icon(Icons.cancel_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
      Expanded(
        child: Padding(
          padding: padding,
          child: builder(),
        ),
      ),
      bottomBuilder != null ? bottomBuilder() : const SizedBox(),
    ],
  );
}
