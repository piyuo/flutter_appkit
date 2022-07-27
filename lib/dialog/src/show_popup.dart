import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// showPopup show popup dialog
/// ```dart
/// final result = await showPopup(
///   context,
///   heightFactor: 0.8,
///   itemBuilder: (index) => const [
///     SizedBox(height: 20),
///     SizedBox(height: 180, child: Placeholder()),
///     Text('hello world'),
///     SizedBox(height: 20),
///   ][index],
///   );
/// ```
Future<T?> showPopup<T>(
  BuildContext context, {
  int itemCount = 1,
  required Widget Function(int) itemBuilder,
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  Decoration? decoration,
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
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
              child: _buildContent(
                context,
                wrapBuilder: wrapBuilder,
                padding: padding,
                builder: () => itemCount > 1
                    ? ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (_, index) => itemBuilder(index),
                      )
                    : itemBuilder(0),
                closeButtonBuilder: closeButtonBuilder,
                topBuilder: topBuilder,
                bottomBuilder: bottomBuilder,
                decoration: decoration,
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
///   itemCount:4,
///   itemBuilder: (index) => const [
///     SizedBox(height: 20),
///     SizedBox(height: 180, child: Placeholder()),
///     Text('hello world'),
///     SizedBox(height: 20),
///   ][index]
///   );
/// ```
Future<T?> showSheet<T>(
  BuildContext context, {
  int itemCount = 1,
  required Widget Function(int) itemBuilder,
  Decoration? decoration,
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
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
    shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(20),
            )),
    builder: (BuildContext context) => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.7,
      child: SafeArea(
          bottom: false,
          child: _buildContent(
            context,
            wrapBuilder: wrapBuilder,
            padding: padding,
            builder: () => itemCount > 1
                ? DraggableScrollableSheet(
                    initialChildSize: 1,
                    minChildSize: 0.9,
                    maxChildSize: 1,
                    snap: true,
                    builder: (_, controller) => ListView.builder(
                      controller: controller,
                      itemCount: itemCount,
                      itemBuilder: (_, index) => itemBuilder(index),
                    ),
                  )
                : itemBuilder(0),
            closeButtonBuilder: closeButtonBuilder,
            topBuilder: topBuilder,
            bottomBuilder: bottomBuilder,
            decoration: decoration,
          )),
    ),
  );
}

/// _buildContent return a widget that will be shown in the dialog or bottom of the sheet
Widget _buildContent<T>(
  BuildContext context, {
  required Widget Function() builder,
  Widget Function(Widget)? wrapBuilder,
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  Decoration? decoration,
}) {
  final content = Stack(
    children: [
      Padding(padding: padding, child: builder()),
      if (closeButtonBuilder != null) closeButtonBuilder(),
      if (closeButtonBuilder == null)
        Positioned(
          top: 13,
          right: 14,
          child: Container(
            width: 19,
            height: 19,
            color: Colors.white,
          ),
        ),
      if (closeButtonBuilder == null)
        Positioned(
          top: -3,
          right: -3,
          child: IconButton(
            iconSize: 38,
            color: Colors.black,
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      topBuilder != null ? topBuilder() : const SizedBox(),
      bottomBuilder != null ? bottomBuilder() : const SizedBox(),
    ],
  );

  if (wrapBuilder != null) {
    return wrapBuilder(content);
  }
  return content;
}
