import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';

abstract class SelectableGrid<T> extends Selectable<T> {
  const SelectableGrid({
    required List<T> items,
    required List<T> selectedItems,
    bool isCheckMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    this.crossAxisCount = 2,
    this.labelBuilder,
    this.borderColor,
    this.selectedBorderColor,
    Color? itemBackgroundColor,
    T? newItem,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          checkMode: isCheckMode,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          itemBackgroundColor: itemBackgroundColor,
          newItem: newItem,
          key: key,
        );

  /// crossAxisCount is the number of children in the cross axis.
  final int crossAxisCount;

  /// builder for build grid item label
  final ItemBuilder<T>? labelBuilder;

  /// borderColor is item border color
  final Color? borderColor;

  /// borderColor is selected item border color
  final Color? selectedBorderColor;

  @override
  Widget onBuildItem(BuildContext context, T item, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: checkMode ? _buildCheckItem(context, item, isSelected) : _buildItem(context, item, isSelected),
        ),
        if (labelBuilder != null) labelBuilder!(item, isSelected),
        const SizedBox(height: 15),
      ],
    );
  }

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: headerBuilder!(),
    );
  }

  /// buildListFooter build footer in list view
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  /// _buildCheckItem is a widget builder for each item in check mode
  Widget _buildCheckItem(BuildContext context, T item, bool isSelected) {
    return Stack(
      children: [
        _buildItem(context, item, isSelected),
        Positioned(
          top: 5,
          left: 10,
          child: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected
                ? context.themeColor(
                    light: Colors.blue.shade600,
                    dark: Colors.blueAccent.withOpacity(0.5),
                  )
                : context.themeColor(
                    light: Colors.grey.shade300,
                    dark: Colors.grey.shade800,
                  ),
          ),
        ),
      ],
    );
  }

  /// _buildItem build grid view item
  Widget _buildItem(BuildContext context, T item, bool isSelected) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: isSelected ? const EdgeInsets.fromLTRB(4, 0, 4, 4) : const EdgeInsets.fromLTRB(5, 1, 5, 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: itemBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: isSelected ? 2 : 1,
          color: isSelected
              ? selectedBorderColor ??
                  context.themeColor(
                    light: Colors.blue.shade700,
                    dark: Colors.blueAccent.shade200,
                  )
              : borderColor ??
                  context.themeColor(
                    light: Colors.grey.shade300,
                    dark: Colors.grey.shade800,
                  ),
        ),
      ),
      child: itemBuilder(item, isSelected),
    );
  }
}
