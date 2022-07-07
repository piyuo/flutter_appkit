import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'show_popup.dart';

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
  EdgeInsets? padding,
  double? maxWidth,
  double? heightFactor,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    backgroundColor: backgroundColor ??
        context.themeColor(
          light: Colors.white,
          dark: Colors.grey.shade800,
        ),
    constraints: BoxConstraints(maxWidth: maxWidth ?? 600),
    isScrollControlled: true,
    shape: borderRadius != null ? RoundedRectangleBorder(borderRadius: borderRadius) : null,
    builder: (BuildContext context) => FractionallySizedBox(
      heightFactor: heightFactor ?? 0.7,
      child: SafeArea(
        bottom: false,
        child: buildDialogContent(
          context,
          builder: () => builder(),
          topBuilder: topBuilder,
          bottomBuilder: bottomBuilder,
          decoration: decoration,
          //constraints: constraints,
          padding: padding ?? const EdgeInsets.fromLTRB(20, 0, 20, 20),
        ),
      ),
    ),
  );
}
