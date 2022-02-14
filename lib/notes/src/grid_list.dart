import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// ItemBuilder build item to display
typedef ItemBuilder<T> = Widget Function(T item, bool isSelected);

abstract class GridList<T> extends StatelessWidget {
  /// GridList is parent widget for list and grid, support pull refresh in mobile device
  const GridList({
    required this.items,
    required this.selectedItems,
    required this.padding,
    this.onItemSelected,
    this.onItemChecked,
    this.crossAxisCount = 1,
    this.headerBuilder,
    this.footerBuilder,
    this.multiSelect = false,
    this.onRefresh,
    this.onLoadMore,
    this.gap = 80,
    Key? key,
  }) : super(key: key);

  /// items is all items need to display
  final List<T> items;

  /// selectedItems is selected items
  final List<T> selectedItems;

  /// crossAxisCount cross item count on axis
  final int crossAxisCount;

  /// headerBuilder build header widget
  final Widget Function()? headerBuilder;

  /// footerBuilder build footer widget
  final Widget Function()? footerBuilder;

  /// onItemSelected is callback when item selected
  final void Function(List<T> items)? onItemSelected;

  /// onItemChecked is callback when item checked
  final void Function(List<T> items)? onItemChecked;

  /// onRefresh is callback when pull refresh
  final Future<void> Function()? onRefresh;

  /// onLoadMore is callback when load more
  final Future<void> Function()? onLoadMore;

  /// multiSelect is true if can multi select
  final bool multiSelect;

  /// padding is item padding
  final EdgeInsets padding;

  /// gap for grid item gap
  final double gap;

  /// buildItem is abstract method for child to build item
  Widget buildItem(BuildContext context, int itemIndex, T item, bool isSelected);

  /// buildHeader build header
  Widget buildHeader(BuildContext context);

  /// buildFooter build footer
  Widget buildFooter(BuildContext context);

  /// _rowCount is actual row count to display
  int get _rowCount {
    int count = 0;
    if (headerBuilder != null) {
      count++;
    }

    int rowCount = (items.length / crossAxisCount).ceil();
    count += rowCount;

    if (footerBuilder != null) {
      count++;
    }
    return count;
  }

  /// _buildItem is build item by itemIndex
  Widget _buildIndexItem(BuildContext context, int itemIndex) {
    final item = items[itemIndex];
    final isSelected = selectedItems.contains(item);
    if (onItemSelected != null || onItemChecked != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!multiSelect) {
            if (!selectedItems.contains(item)) {
              onItemSelected?.call([item]);
            }
            return;
          }
          var newLSelected = selectedItems.toList();
          if (newLSelected.contains(item)) {
            newLSelected.remove(item);
          } else {
            newLSelected.add(item);
          }
          onItemChecked?.call(newLSelected);
        },
        child: buildItem(context, itemIndex, item, isSelected),
      );
    }
    return buildItem(context, itemIndex, item, isSelected);
  }

  /// _buildRow build row by rowIndex
  Widget _buildRow(BuildContext context, int rowIndex) {
    int lastIndex = items.length - 1;
    if (footerBuilder != null && lastIndex > 0) {
      lastIndex--;
    }

    var children = <Widget>[];
    int startIndex = rowIndex * crossAxisCount;
    final endIndex = startIndex + crossAxisCount;
    for (int i = startIndex; i < endIndex; i++) {
      children.add(
        Expanded(
          child: i <= lastIndex ? _buildIndexItem(context, i) : const SizedBox(),
        ),
      );
      if (i != endIndex - 1) {
        children.add(SizedBox(width: gap));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: delta.RefreshMoreView(
          onRefresh: onRefresh,
          onLoadMore: onLoadMore,
          itemCount: _rowCount,
          itemBuilder: (BuildContext context, int index) {
            int rowIndex = index;
            if (headerBuilder != null) {
              if (index == 0) {
                return buildHeader(context);
              }
              rowIndex--;
            }

            if (footerBuilder != null && index == _rowCount - 1) {
              return buildFooter(context);
            }

            if (crossAxisCount == 1) {
              return _buildIndexItem(context, rowIndex);
            }
            return _buildRow(context, rowIndex);
          },
        ));
  }
}
