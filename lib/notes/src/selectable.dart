import 'package:flutter/material.dart';

/// Builder build item to display
typedef ItemBuilder<T> = Widget Function(T item, bool isSelected);

abstract class Selectable<T> extends StatelessWidget {
  const Selectable({
    required this.items,
    required this.selectedItems,
    required this.itemBuilder,
    this.checkMode = false,
    this.onItemSelected,
    this.onItemChecked,
    this.headerBuilder,
    this.footerBuilder,
    this.itemBackgroundColor,
    this.newItem,
    Key? key,
  }) : super(key: key);

  /// items is all items need to display
  final List<T> items;

  /// selectedItems is selected items
  final List<T> selectedItems;

  /// checkMode is a boolean value that indicates whether the list is in check mode
  final bool checkMode;

  /// itemBuilder is a item builder for list view
  final ItemBuilder<T> itemBuilder;

  /// itemBackgroundColor is the background color of item
  final Color? itemBackgroundColor;

  /// onItemSelected is callback when item selected
  final void Function(List<T> items)? onItemSelected;

  /// onItemChecked is callback when item checked
  final void Function(List<T> items)? onItemChecked;

  /// headerBuilder build header widget
  final Widget Function()? headerBuilder;

  /// footerBuilder build footer widget
  final Widget Function()? footerBuilder;

  /// newItem is not null mean user is editing a new item
  final T? newItem;

  /// onBuildItem call when item need to build
  Widget onBuildItem(BuildContext context, T item, bool isSelected);

  /// buildItem is build item by itemIndex
  Widget buildItem(BuildContext context, T item) {
    var isSelected = false;
    if (newItem != null && item == newItem) {
      isSelected = true;
    } else if (newItem == null && selectedItems.contains(item)) {
      isSelected = true;
    }
    if (onItemSelected != null || onItemChecked != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!checkMode) {
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
        child: onBuildItem(context, item, isSelected),
      );
    }
    return onBuildItem(context, item, isSelected);
  }
}
