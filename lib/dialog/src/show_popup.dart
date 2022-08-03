import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// cupertinoBottomSheet wrap child so showSheet can work normally
Widget cupertinoBottomSheet(Widget child) {
  return CupertinoScaffold(body: child);
}

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
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) async {
  Widget build() => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.85,
      child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 600),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: backgroundColor ??
                    context.themeColor(
                      light: Colors.grey.shade100,
                      dark: Colors.grey.shade900,
                    ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1), // changes position of shadow
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16)),
              ),
              child: _buildDialogWithContent(
                context,
                itemCount: itemCount,
                itemBuilder: itemBuilder,
                closeButtonBuilder: closeButtonBuilder,
                topBuilder: topBuilder,
                bottomBuilder: bottomBuilder,
                wrapBuilder: wrapBuilder,
                backgroundColor: backgroundColor,
                borderRadius: borderRadius,
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
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  double? borderRadius,
  bool expand = false,
  bool fromRoot = true,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) async {
  MediaQueryData query = MediaQuery.of(context);
  double screenWidth = query.size.width;
  Widget _builder(BuildContext context) => FractionallySizedBox(
        heightFactor: heightFactor ?? 0.85,
        child: SafeArea(
            bottom: false,
            child: _buildDialogWithContent(
              context,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              closeButtonBuilder: closeButtonBuilder,
              topBuilder: topBuilder,
              bottomBuilder: bottomBuilder,
              wrapBuilder: wrapBuilder,
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              padding: padding,
              controller: ModalScrollController.of(context),
            )),
      );

  return screenWidth <= 600
      ? fromRoot
          // bottom sheet from root
          ? await CupertinoScaffold.showCupertinoModalBottomSheet<T>(
              context: context,
              backgroundColor: backgroundColor ??
                  context.themeColor(
                    light: Colors.grey.shade100,
                    dark: Colors.grey.shade900,
                  ),
              expand: expand,
              builder: _builder,
            )
          // bottom sheet from current context
          : await showCupertinoModalBottomSheet<T>(
              context: context,
              expand: expand,
              builder: _builder,
            )
      // bottom sheet dialog for large screen
      : await showCustomModalBottomSheet<T>(
          context: context,
          containerWidget: (_, animation, child) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => constraints.maxWidth > 600
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: ((constraints.maxWidth - 600) / 2), vertical: 20),
                    child: child,
                  )
                : child,
          ),
          elevation: 8,
          expand: expand,
          builder: _builder,
        );
}

/// _buildDialogWithContent build dialog and content
Widget _buildDialogWithContent(
  BuildContext context, {
  int itemCount = 1,
  required Widget Function(int) itemBuilder,
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  Color? backgroundColor,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  ScrollController? controller,
}) {
  final content = Stack(
    children: [
      Padding(
          padding: padding,
          child: itemCount > 1
              ? ListView.builder(
                  controller: controller,
                  itemCount: itemCount,
                  itemBuilder: (_, index) => itemBuilder(index),
                )
              : itemBuilder(0)),
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
            icon: const Icon(Icons.cancel, shadows: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 5,
              ),
            ]),
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

  return Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: backgroundColor ??
          context.themeColor(
            light: Colors.grey.shade100,
            dark: Colors.grey.shade900,
          ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(1, 1), // changes position of shadow
        )
      ],
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16)),
    ),
    child: content,
  );
}
