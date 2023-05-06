import 'package:flutter/material.dart';
import 'toolbar.dart';

/// ToolSpacer show expanded space on toolbar
/// ```dart
/// ToolSpacer(),
/// ```
class ToolSpacer extends ToolItem {
  /// ToolSpacer show expanded space on toolbar
  /// ```dart
  /// ToolSpacer(),
  /// ```
  ToolSpacer({
    double space = 0,
  }) : super(width: 0, space: space);

  @override
  Widget barBuild(BuildContext context) {
    return const Spacer();
  }

  @override
  Widget sheetBuild(BuildContext context) {
    return const Divider();
  }

  @override
  List<PopupMenuEntry> menuBuild(BuildContext context, bool first, bool last) {
    return [const PopupMenuDivider()];
  }
}
