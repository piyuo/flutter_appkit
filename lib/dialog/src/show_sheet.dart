import 'dart:async';
import 'package:flutter/material.dart';
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
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
  double maxWidth = 600,
  double heightFactor = 0.7,
  BorderRadiusGeometry borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    constraints: BoxConstraints(maxWidth: maxWidth),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
    builder: (BuildContext context) => FractionallySizedBox(
      heightFactor: heightFactor,
      child: SafeArea(
        bottom: false,
        child: buildDialogContent(
          context,
          builder: () => builder(),
          topBuilder: topBuilder,
          bottomBuilder: bottomBuilder,
          decoration: decoration,
          //constraints: constraints,
          padding: padding,
        ),
      ),
    ),
  );
}
/*Future<T?> showSlideSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context, ScrollController scrollController) builder,
  Decoration? decoration,
  Widget? closeButton,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 600),
  EdgeInsets padding = const EdgeInsets.fromLTRB(20, 50, 20, 0),
  double initHeight = 0.7,
  double maxHeight = 0.7,
  Widget Function()? titleBuilder, // return Positioned(left: 15,top: 10,child: title),
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
                decoration: decoration ??
                    BoxDecoration(
                      color: context.themeColor(
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
                child: closeButton ??
                    IconButton(
                      iconSize: 32,
                      color: Colors.grey,
                      icon: const Icon(Icons.cancel_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
              ),
              if (titleBuilder != null) titleBuilder()
            ]),
          ),
        )),
  );
}
*/