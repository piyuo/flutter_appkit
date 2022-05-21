import 'package:flutter/material.dart';

/// ToolItem define item in toolbar
abstract class ToolItem {
  /// ToolItem define item in toolbar
  ToolItem({required this.width, this.space});

  /// width of item, every item must specify width in order to calculate toolbar width
  final double width;

  /// space between item
  double? space;
}

/// ToolControl define control item in toolbar
abstract class ToolControl extends ToolItem {
  /// ToolControl define control item in toolbar
  ToolControl({
    required this.label,
    required double width,
    double? space,
    this.text,
    this.icon,
  }) : super(width: width, space: space);

  /// text display value of control, display icon if text is null
  final String? text;

  /// icon of control, display label if text is null
  final IconData? icon;

  /// label of control
  final String label;
}

/// ToolButton define button item in toolbar
/// ```dart
/// ToolButton(
///   label: 'New File',
///   icon: Icons.new_label,
///   value: 'new_file',
///   space: 10,
///  ),
/// ```
class ToolButton extends ToolControl {
  /// ToolButton define button item in toolbar
  /// ```dart
  /// ToolButton(
  ///   label: 'New File',
  ///   icon: Icons.new_label,
  ///   value: 'new_file',
  ///   space: 10,
  ///  ),
  /// ```
  ToolButton({
    double width = 38,
    double? space,
    required String label,
    this.onPressed,
    String? text,
    IconData? icon,
    this.active = false,
  }) : super(width: width, label: label, space: space, text: text, icon: icon);

  final bool active;

  /// onPressed called when user press button
  final VoidCallback? onPressed;
}

/// ToolSelection define item in toolbar
/// ```dart
///  ToolSelection<String>(
///   width: 120,
///   text: 'page 2 of more',
///   label: 'rows per page',
///   selection: {
///     '10': '10 rows',
///     '20': '20 rows',
///     '50': '50 rows',
///   },
/// ),
/// ```
class ToolSelection extends ToolControl {
  /// ToolSelection define item in toolbar
  /// ```dart
  ///  ToolSelection<String>(
  ///   width: 120,
  ///   text: 'page 2 of more',
  ///   label: 'rows per page',
  ///   selection: {
  ///     '10': '10 rows',
  ///     '20': '20 rows',
  ///     '50': '50 rows',
  ///   },
  /// ),
  /// ```
  ToolSelection({
    double width = 60,
    double? space,
    required String label,
    required this.selection,
    this.onPressed,
    this.selectedValue,
    String? text,
    IconData? icon,
  }) : super(width: width, label: label, icon: icon, space: space, text: text);

  final Map<dynamic, String> selection;

  /// onPressed called when user press button
  final void Function(dynamic value)? onPressed;

  /// selectedValue is selection selected value
  dynamic selectedValue;
}

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
}
