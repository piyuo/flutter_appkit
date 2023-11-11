import 'package:flutter/material.dart';
import 'selectable.dart';

class SimpleList<T> extends Selectable<T> {
  const SimpleList({
    required super.items,
    required super.selectedItems,
    super.checkMode,
    super.onItemSelected,
    super.onItemChecked,
    Color? selectedColor,
    required super.itemBuilder,
    super.headerBuilder,
    super.footerBuilder,
    super.key,
  }) : super(
          itemDecorationBuilder: defaultListDecorationBuilder,
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
        return buildItem(context, items[rowIndex]);
      },
    );
  }
}
