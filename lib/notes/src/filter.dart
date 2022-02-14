import 'package:flutter/material.dart';

class Filter<T> {
  /// Filter contains a list of item in view
  /// ```dart
  ///  Filter<String>(
  ///      label: 'Inbox',
  ///      value:'inbox',
  ///      icon: Icons.inbox,
  ///      count: 0,
  ///    ),
  /// ```
  const Filter({
    required this.label,
    required this.value,
    this.category = '',
    this.count,
    this.icon,
    this.selected = false,
  });

  /// title is the title of the filter
  final String label;

  /// value is value to return when filter is selected
  final T value;

  /// category is the category of the filter
  final String category;

  /// count is the number of items in the filter
  final int? count;

  /// icon is the icon of the filter
  final IconData? icon;

  /// selected is the filter has been selected
  final bool selected;
}

/// findCategories returns a list of categories for the given list of filters
List<String> findCategories(final List<Filter> filters) {
  final List<String> categories = [];
  for (final Filter filter in filters) {
    if (!categories.contains(filter.category)) {
      categories.add(filter.category);
    }
  }
  return categories..sort();
}
