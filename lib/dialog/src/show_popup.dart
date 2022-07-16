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
  Widget Function(Widget)? wrapBuilder,
  Decoration? decoration,
  double? maxWidth,
  double? heightFactor,
  EdgeInsets? padding,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
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
                          light: Colors.grey.shade100,
                          dark: Colors.grey.shade900,
                        ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(3, 3), // changes position of shadow
                      )
                    ],
                    borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
                  ),
              child: _buildDialogContent(
                context,
                builder: builder,
                topBuilder: topBuilder,
                bottomBuilder: bottomBuilder,
                wrapBuilder: wrapBuilder,
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

/// showSheet show popup sheet from the bottom
/// ```dart
/// final result = await showSheet(
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
Future<T?> showSheet<T>(
  BuildContext context, {
  required Widget Function() builder,
  Decoration? decoration,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  EdgeInsets? padding,
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    clipBehavior: Clip.antiAlias,
    elevation: 8,
    backgroundColor: backgroundColor ??
        context.themeColor(
          light: Colors.grey.shade100,
          dark: Colors.grey.shade900,
        ),
    constraints: BoxConstraints(maxWidth: maxWidth ?? 600),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: borderRadius ?? const BorderRadius.vertical(top: Radius.circular(16))),
    builder: (BuildContext context) => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.7,
      child: SafeArea(
        bottom: false,
        child: _buildDialogContent(
          context,
          builder: () => builder(),
          topBuilder: topBuilder,
          bottomBuilder: bottomBuilder,
          wrapBuilder: wrapBuilder,
          decoration: decoration,
          padding: padding ?? const EdgeInsets.fromLTRB(20, 0, 20, 20),
        ),
      ),
    ),
  );
}

/// buildDialogContent return a widget that will be shown in the dialog or bottom of the sheet
Widget _buildDialogContent<T>(
  BuildContext context, {
  required Widget Function() builder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  Decoration? decoration,
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
}) {
  final content = Column(
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

  if (wrapBuilder != null) {
    return wrapBuilder(content);
  }
  return content;
}
