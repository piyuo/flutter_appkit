import 'package:flutter/material.dart';
import 'selectable.dart';
import 'selectable_list.dart';

class SimpleList<T> extends SelectableList<T> {
  const SimpleList({
    required List<T> items,
    required List<T> selectedItems,
    bool checkMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    Color? selectedColor,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          checkMode: checkMode,
          selectedColor: selectedColor,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          key: key,
        );

  /// rowCount is actual row count to display
  int get _rowCount {
    int count = items.length;
    if (headerBuilder != null) {
      count++;
    }
    if (footerBuilder != null) {
      count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _rowCount,
      itemBuilder: (BuildContext context, int index) {
        int rowIndex = index;
        if (headerBuilder != null) {
          if (index == 0) {
            return headerBuilder!();
          }
          rowIndex--;
        }
        if (footerBuilder != null && index == _rowCount - 1) {
          return footerBuilder!();
        }
        return buildItem(context, rowIndex);
      },
    );
  }
}
