import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showPopup show popup dialog
/// ```dart
/// final result = await showPopup(
///   context,
///   heightFactor: 0.8,
///   builder: () => ListView(
///   children: const [
///     SizedBox(height: 20),
///     SizedBox(height: 180, child: Placeholder()),
///     Text('hello world'),
///     SizedBox(height: 20),
///   ],
///   );
/// ```
Future<T?> showPopup<T>(
  BuildContext context, {
  required Widget Function() builder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Decoration? decoration,
  double? maxWidth,
  double? heightFactor,
  EdgeInsets? padding,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius = const BorderRadius.all(Radius.circular(16)),
}) async {
  Widget build() => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.7,
      child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 600),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: decoration ??
                  BoxDecoration(
                    color: backgroundColor ??
                        context.themeColor(
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
                padding: padding ?? const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
