import 'package:flutter/material.dart';
import 'selectable.dart';
import 'selectable_grid.dart';

class SimpleGrid<T> extends SelectableGrid<T> {
  const SimpleGrid({
    required List<T> items,
    required List<T> selectedItems,
    bool checkMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    ItemBuilder<T>? labelBuilder,
    Color? borderColor,
    Color? selectedBorderColor,
    int crossAxisCount = 2,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          isCheckMode: checkMode,
          crossAxisCount: crossAxisCount,
          labelBuilder: labelBuilder,
          borderColor: borderColor,
          selectedBorderColor: selectedBorderColor,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rowCount,
      itemBuilder: (BuildContext context, int index) {
        if (headerBuilder != null && index == 0) {
          return buildHeader(context);
        }
        if (footerBuilder != null && index == rowCount - 1) {
          return buildFooter(context);
        }
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => buildItem(context, items[index]),
        );
      },
    );
  }
}
