import 'package:flutter/material.dart';

class Tag<T> {
  /// Tag contains a list of item in view
  /// ```dart
  ///  Tag<String>(
  ///      label: 'Inbox',
  ///      value:'inbox',
  ///      icon: Icons.inbox,
  ///      count: 0,
  ///    ),
  /// ```
  Tag({
    required this.label,
    required this.value,
    this.category = '',
    this.count,
    this.icon,
    this.selected = false,
  });

  /// title is the title of the tag
  final String label;

  /// value is value to return when tag is selected
  final T value;

  /// category is the category of the tag
  final String category;

  /// count is the number of items in the tag
  final int? count;

  /// icon is the icon of the tag
  final IconData? icon;

  /// selected is the tag has been selected
  bool selected = false;
}

/// findCategories returns a list of categories for the given list of tags
List<String> findCategories(final List<Tag> tags) {
  final List<String> categories = [];
  for (final Tag tag in tags) {
    if (!categories.contains(tag.category)) {
      categories.add(tag.category);
    }
  }
  return categories..sort();
}
