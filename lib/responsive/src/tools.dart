import 'package:flutter/material.dart';

/// ToolCallback define the callback for toolbar button
typedef ToolCallback<T> = void Function(T value);

/// ToolItem define item in toolbar
abstract class ToolItem<T> {
  /// ToolItem define item in toolbar
  ToolItem({required this.width, this.space});

  /// width of item, every item must specify width in order to calculate toolbar width
  final double width;

  /// space between item
  double? space;
}

/// ToolControl define control item in toolbar
abstract class ToolControl<T> extends ToolItem<T> {
  /// ToolControl define control item in toolbar
  ToolControl({
    required double width,
    double? space,
    this.value,
    required this.label,
    this.text,
    this.icon,
  }) : super(width: width, space: space);

  /// text display value of control, display icon if text is null
  final String? text;

  /// icon of control, display label if text is null
  final IconData? icon;

  /// label of control
  final String label;

  /// value of control
  final T? value;
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
class ToolButton<T> extends ToolControl<T> {
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
    required T? value,
    String? text,
    IconData? icon,
    this.active = false,
  }) : super(width: width, label: label, value: value, space: space, text: text, icon: icon);

  final bool active;
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
class ToolSelection<T> extends ToolControl<T> {
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
    String? text,
    IconData? icon,
    T? value,
  }) : super(width: width, label: label, icon: icon, space: space, text: text);

  final Map<T, String>? selection;
}

/// ToolSpacer show expanded space on toolbar
/// ```dart
/// ToolSpacer(),
/// ```
class ToolSpacer<T> extends ToolItem<T> {
  /// ToolSpacer show expanded space on toolbar
  /// ```dart
  /// ToolSpacer(),
  /// ```
  ToolSpacer({
    double space = 0,
  }) : super(width: 0, space: space);
}
