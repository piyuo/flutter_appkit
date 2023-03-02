import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/types/types.dart' as types;
import 'responsive.dart';

/// showResponsiveDialog responsive show popup if big screen, bottom sheet in small screen
/// ```dart
/// final result = await showDialog(
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
Future<T?> showResponsiveDialog<T>(
  BuildContext context, {
  int itemCount = 1,
  required types.WidgetContextIndexBuilder itemBuilder,
  types.WidgetContextBuilder? closeButtonBuilder,
  types.WidgetContextBuilder? topBuilder,
  types.WidgetContextBuilder? bottomBuilder,
  types.WidgetContextWrapper? wrapper,
  double? maxWidth,
  double? maxHeight,
  double? heightFactor = 0.7,
  Color? backgroundColor,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  bool fromRoot = true,
}) async {
  if (phoneScreen) {
    return await dialog.showSheet<T>(
      context,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      closeButtonBuilder: closeButtonBuilder,
      topBuilder: topBuilder,
      wrapper: wrapper,
      bottomBuilder: bottomBuilder,
      padding: padding,
      maxWidth: maxWidth ?? 600,
      maxHeight: maxHeight,
      heightFactor: heightFactor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      fromRoot: fromRoot,
    );
  }

  return await dialog.showPopup<T>(
    context,
    itemCount: itemCount,
    itemBuilder: itemBuilder,
    closeButtonBuilder: closeButtonBuilder,
    topBuilder: topBuilder,
    bottomBuilder: bottomBuilder,
    wrapper: wrapper,
    padding: padding,
    maxWidth: maxWidth ?? 800,
    maxHeight: maxHeight,
    heightFactor: heightFactor,
    backgroundColor: backgroundColor,
    borderRadius: borderRadius,
  );
}
