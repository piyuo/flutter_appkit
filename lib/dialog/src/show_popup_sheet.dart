import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/general/general.dart' as general;
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
  required general.WidgetContextIndexBuilder itemBuilder,
  general.WidgetContextBuilder? closeButtonBuilder,
  general.WidgetContextBuilder? topBuilder,
  general.WidgetContextBuilder? bottomBuilder,
  general.WidgetContextWrapper? wrapper,
  double? maxWidth,
  double? maxHeight,
  double? heightFactor,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) async {
  Widget build(BuildContext ctx) => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.85,
      child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 600, maxHeight: maxHeight ?? double.infinity),
            child: _buildDialogWithContent(
              ctx,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              closeButtonBuilder: closeButtonBuilder,
              topBuilder: topBuilder,
              bottomBuilder: bottomBuilder,
              wrapper: wrapper,
              borderRadius: borderRadius,
              padding: padding,
            ),
          )));

  return await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(scale: curve, child: build(ctx));
    },
    pageBuilder: (ctx, a1, a2) => build(ctx),
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
  required general.WidgetContextIndexBuilder itemBuilder,
  general.WidgetContextBuilder? closeButtonBuilder,
  general.WidgetContextBuilder? topBuilder,
  general.WidgetContextBuilder? bottomBuilder,
  general.WidgetContextWrapper? wrapper,
  double? maxWidth,
  double? maxHeight,
  double? heightFactor,
  Color? backgroundColor,
  double? borderRadius,
  bool expand = false,
  bool fromRoot = true,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) async {
  MediaQueryData query = MediaQuery.of(context);
  double screenWidth = query.size.width;
  Widget builder(BuildContext ctx) => ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity, maxHeight: maxHeight ?? double.infinity),
      child: FractionallySizedBox(
        heightFactor: heightFactor ?? 0.85,
        child: SafeArea(
            bottom: false,
            child: _buildDialogWithContent(
              ctx,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              closeButtonBuilder: closeButtonBuilder,
              topBuilder: topBuilder,
              bottomBuilder: bottomBuilder,
              wrapper: wrapper,
              borderRadius: borderRadius,
              padding: padding,
              //controller: ModalScrollController.of(context), no use for now, it will cause problem with change layout
            )),
      ));

  return screenWidth <= 600
      ? fromRoot
          // bottom sheet from root
          ? await CupertinoScaffold.showCupertinoModalBottomSheet<T>(
              context: context,
              backgroundColor: backgroundColor,
              expand: expand,
              builder: builder,
            )
          // bottom sheet from current context
          : await showCupertinoModalBottomSheet<T>(
              context: context,
              expand: expand,
              builder: builder,
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
          builder: builder,
        );
}

/// _buildDialogWithContent build dialog and content
Widget _buildDialogWithContent(
  BuildContext context, {
  int itemCount = 1,
  required general.WidgetContextIndexBuilder itemBuilder,
  general.WidgetContextBuilder? closeButtonBuilder,
  general.WidgetContextBuilder? topBuilder,
  general.WidgetContextBuilder? bottomBuilder,
  general.WidgetContextWrapper? wrapper,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  ScrollController? controller,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  Widget content = Stack(
    children: [
      Padding(
          padding: padding,
          child: itemCount > 1
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: controller,
                  itemCount: itemCount,
                  itemBuilder: (_, index) => itemBuilder(context, index),
                )
              : itemBuilder(context, 0)),
      if (closeButtonBuilder != null) closeButtonBuilder(context),
      if (closeButtonBuilder == null)
        Positioned(
          top: 16,
          right: 17,
          child: Container(
            width: 19,
            height: 19,
            color: colorScheme.onSecondary,
          ),
        ),
      if (closeButtonBuilder == null)
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            iconSize: 38,
            color: colorScheme.secondary,
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      topBuilder != null ? topBuilder(context) : const SizedBox(),
      bottomBuilder != null ? bottomBuilder(context) : const SizedBox(),
    ],
  );

  return Material(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16)),
    clipBehavior: Clip.antiAlias,
    elevation: 5,
    child: wrapper != null ? wrapper(context, content) : content,
  );
}
