import 'package:libcli/delta/delta.dart' as delta;
import 'package:flutter/material.dart';
import 'responsive.dart';

/// ResponsiveDrawer show responsive drawer
class ResponsiveDrawer extends StatelessWidget {
  /// ```dart
  /// drawer: ResponsiveDrawer(
  ///   itemCount: 1,
  ///   itemBuilder: (context, index) => ListTile(
  ///     title: Text('$index'),
  ///   ),
  /// ),
  /// endDrawer: ResponsiveDrawer(
  ///   isEndDrawer: true,
  ///   itemCount: 1,
  ///   itemBuilder: (context, index) => ListTile(
  ///     title: Text('$index'),
  ///   ),
  /// ),
  /// ```
  const ResponsiveDrawer({
    required this.itemBuilder,
    required this.itemCount,
    this.isEndDrawer = false,
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  /// itemBuilder Creates a scrollable, linear array of widgets that are created on demand.
  final Widget Function(BuildContext, int) itemBuilder;

  /// itemCount is item count in the drawer
  final int itemCount;

  /// isEndDrawer is true mean this is end drawer
  final bool isEndDrawer;

  /// padding is padding for drawer
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: phoneScreen ? const EdgeInsets.symmetric(vertical: 40, horizontal: 25) : null,
            constraints: phoneScreen ? null : const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: context.themeColor(light: Colors.grey.shade100, dark: Colors.grey.shade900),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  spreadRadius: 2,
                  blurRadius: 1,
                )
              ],
              borderRadius: phoneScreen
                  ? const BorderRadius.all(Radius.circular(20.0))
                  : isEndDrawer
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListView.builder(
              itemBuilder: (_, index) {
                if (index == 0) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }

                return itemBuilder(context, index - 1);
              },
              itemCount: itemCount + 1,
              padding: padding,
            )));
  }
}
