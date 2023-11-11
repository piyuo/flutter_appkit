import 'package:flutter/material.dart';
import 'selectable.dart';

class SimpleGrid<T> extends Selectable<T> {
  const SimpleGrid({
    required super.items,
    required super.selectedItems,
    bool checkMode = false,
    super.onItemSelected,
    super.onItemChecked,
    required super.itemBuilder,
    super.headerBuilder,
    super.footerBuilder,
    Color? borderColor,
    Color? selectedBorderColor,
    this.crossAxisCount = 2,
    super.key,
  }) : super(
          itemDecorationBuilder: defaultGridDecorationBuilder,
        );

  /// crossAxisCount is the number of children in the cross axis.
  final int crossAxisCount;

  /// rowCount is actual row count to display
  int get rowCount {
    int count = 1;
    if (headerBuilder != null) {
      count++;
    }
    if (footerBuilder != null) {
      count++;
    }
    return count;
  }

  /// buildHeader build header in list view
  Widget buildHeader(BuildContext context) {
    return headerBuilder!();
  }

  /// buildListFooter build footer in list view
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

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
