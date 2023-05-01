import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

/// GroupListView show a list with group, T is the type of item, K is the type of group
class GroupListView<T, K> extends StatelessWidget {
  const GroupListView({
    required this.items,
    required this.groupBy,
    required this.groupBuilder,
    required this.itemBuilder,
    this.itemComparator,
    this.orderAscending = true,
    this.scrollController,
    this.separator = const Divider(),
    this.groupBackgroundColor = Colors.transparent,
    Key? key,
  }) : super(key: key);

  /// items keep all list item
  final List<T> items;

  /// groupBy is a function to group item by key
  final K Function(T) groupBy;

  /// groupBuilder build group widget
  final Widget Function(K) groupBuilder;

  /// itemBuilder build item widget
  final Widget Function(T) itemBuilder;

  /// itemComparator is a function to compare two item
  final int Function(T, T)? itemComparator;

  /// separator is a widget to separate item
  final Widget separator;

  /// orderAscending is a bool to control order
  final bool orderAscending;

  /// scrollController is a controller to control scroll
  final ScrollController? scrollController;

  final Color groupBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return GroupedListView<T, K>(
      elements: items,
      groupBy: groupBy,
      groupSeparatorBuilder: groupBuilder,
      separator: separator,
      itemBuilder: (_, T item) => itemBuilder(item),
      itemComparator: itemComparator,
      useStickyGroupSeparators: true,
      floatingHeader: false,
      stickyHeaderBackgroundColor: groupBackgroundColor,
      order: orderAscending ? GroupedListOrder.ASC : GroupedListOrder.DESC,
    );
  }
}
