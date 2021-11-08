import 'package:flutter/material.dart';

class ListItem<T> {
  ListItem(
    this.key, {
    this.text,
    this.icon,
    this.title,
  });

  /// key is item key
  final T key;

  /// text is item text, use key to display if text not set
  final String? text;

  /// title is item title
  final String? title;

  /// icon is item icon
  final IconData? icon;
}

/// ListItemBuilder build custom item ui
typedef ListItemBuilder<T, V> = Widget? Function(BuildContext context, T key, V item, bool selected);
