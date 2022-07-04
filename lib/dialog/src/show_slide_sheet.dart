import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:bottom_sheet/bottom_sheet.dart';

/// showSlideSheet show popup sheet from the bottom
/// ```dart
/// final result = await showSlideSheet(
///   context,
///   builder: (context, scrollController) => ListView(
///      controller: scrollController,
///      children: const [
///        Text('sheetContent'),
///      ],
///   ))
/// ```
Future<T?> showSlideSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context, ScrollController scrollController) builder,
  Color? color,
  Color closeButtonColor = Colors.grey,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 600),
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 50, 20, 0),
  double initHeight = 0.7,
  double maxHeight = 0.9,
  Widget? title,
  double titleLeft = 15,
  double titleTop = 10,
}) async {
  return await showFlexibleBottomSheet<T>(
    initHeight: initHeight,
    maxHeight: maxHeight,
    context: context,
    anchors: [
      initHeight,
      if (maxHeight != initHeight) maxHeight,
    ],
    bottomSheetColor: Colors.transparent,
    builder: (BuildContext context, ScrollController scrollController, double bottomSheetOffset) => SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: constraints,
            child: Stack(children: [
              Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: color ??
                      context.themeColor(
                        light: Colors.white,
                        dark: Colors.grey.shade800,
                      ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: builder(context, scrollController),
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
              if (title != null)
                Positioned(
                  left: titleLeft,
                  top: titleTop,
                  child: title,
                ),
            ]),
          ),
        )),
  );
}
