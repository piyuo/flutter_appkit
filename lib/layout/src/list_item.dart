import 'package:flutter/material.dart';

class ListItem<T> {
  ListItem(
    this.key, {
    this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  /// key is item key
  final T key;

  /// title for the item
  final String? title;

  /// subtitle for the item
  final String? subtitle;

  /// icon is item icon
  final IconData? icon;

  /// iconColor set color of icon
  final Color? iconColor;
}

/// ListItemBuilder build custom item ui
typedef ListItemBuilder<T, V> = Widget? Function(BuildContext context, T key, V item, bool selected);
