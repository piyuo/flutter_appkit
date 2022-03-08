import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:bottom_sheet/bottom_sheet.dart';

/// showSlideSheet show popup sheet from the bottom
/// ```dart
/// final result = await showSlideSheet(
///      context,
///      children: const [
///        SizedBox(height: 30),
///        SizedBox(height: 80, child: Placeholder()),
///        SizedBox(height: 120),
///      ],
///    )
/// ```
Future<T?> showSlideSheet<T>(
  BuildContext context, {
  required List<Widget> children,
  Color? color,
  Color barrierColor = Colors.grey,
  Color closeButtonColor = Colors.grey,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 600),
  EdgeInsets padding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
}) async {
  return await showFlexibleBottomSheet<T>(
    initHeight: 0.6,
    maxHeight: 0.92,
    context: context,
    anchors: [0.6, 0.92],
    builder: (
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
    ) =>
        SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: constraints,
                child: Stack(children: [
                  Container(
                    padding: padding,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: color ??
                          context.themeColor(
                            light: Colors.white,
                            dark: Colors.grey.shade800,
                          ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      controller: scrollController,
                      children: children,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      iconSize: 32,
                      color: closeButtonColor,
                      icon: const Icon(Icons.cancel_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ]),
              ),
            )),
  );
}
