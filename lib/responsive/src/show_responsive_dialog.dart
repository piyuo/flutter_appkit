import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'responsive1.dart';

/// showResponsiveDialog responsive show popup if big screen, bottom sheet in small screen
/// ```dart
/// final result = await showDialog(
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
Future<T?> showResponsiveDialog<T>(
  BuildContext context, {
  required Widget Function() builder,
  Decoration? decoration,
  Widget Function()? topBuilder,
  Widget Function()? bottomBuilder,
  EdgeInsets? padding,
  double? maxWidth,
  double? heightFactor = 0.7,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
}) async {
  if (phoneScreen) {
    return await dialog.showSheet<T>(
      context,
      builder: builder,
      decoration: decoration,
      topBuilder: topBuilder,
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
    builder: builder,
    decoration: decoration,
    topBuilder: topBuilder,
    bottomBuilder: bottomBuilder,
    padding: padding,
    maxWidth: maxWidth ?? 800,
    heightFactor: heightFactor,
    backgroundColor: backgroundColor,
    borderRadius: borderRadius,
  );
}
