import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'responsive1.dart';

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
  required Widget Function(int) itemBuilder,
  Widget Function()? closeButtonBuilder,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  Widget Function(Widget)? wrapBuilder,
  double? maxWidth,
  double? heightFactor = 0.7,
  Color? backgroundColor,
  double? borderRadius,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) async {
  if (phoneScreen) {
    return await dialog.showSheet<T>(
      context,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      closeButtonBuilder: closeButtonBuilder,
      topBuilder: topBuilder,
      wrapBuilder: wrapBuilder,
      bottomBuilder: bottomBuilder,
      padding: padding,
      maxWidth: maxWidth ?? 600,
      heightFactor: heightFactor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    );
  }

  return await dialog.showPopup<T>(
    context,
    itemCount: itemCount,
    itemBuilder: itemBuilder,
    closeButtonBuilder: closeButtonBuilder,
    topBuilder: topBuilder,
    bottomBuilder: bottomBuilder,
    wrapBuilder: wrapBuilder,
    padding: padding,
    maxWidth: maxWidth ?? 800,
    heightFactor: heightFactor,
    backgroundColor: backgroundColor,
    borderRadius: borderRadius,
  );
}
