import 'package:flutter/material.dart';
import 'toolbar.dart';

/// ToolText show text toolbar
class ToolText extends ToolItem {
  /// ToolSpacer show expanded space on toolbar
  /// ```dart
  /// ToolSpacer(),
  /// ```
  ToolText({
    required this.label,
    double space = 0,
  }) : super(width: 0, space: space);

  /// label of control
  final String label;

  @override
  Widget barBuild(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(label, style: TextStyle(color: colorScheme.onSurface));
  }

  @override
  Widget sheetBuild(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      enableFeedback: true,
      title: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  List<PopupMenuEntry> menuBuild(BuildContext context, bool first, bool last) {
    return [
      PopupMenuItem(
          child: ListTile(
              title: Text(
        label,
        textAlign: TextAlign.center,
      )))
    ];
  }
}
