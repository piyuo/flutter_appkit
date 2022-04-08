import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'selectable.dart';

abstract class SelectableGrid<T> extends Selectable<T> {
  const SelectableGrid({
    required List<T> items,
    required List<T> selectedItems,
    bool checkMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    this.crossAxisCount = 2,
    this.labelBuilder,
    this.borderColor,
    this.selectedBorderColor,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          checkMode: checkMode,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
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
  Widget onBuildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: checkMode
              ? _buildCheckItem(context, itemIndex, item, isSelected)
              : _buildItem(context, itemIndex, item, isSelected),
        ),
        if (labelBuilder != null) labelBuilder!(item, isSelected),
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

  /// buildListHeader build header in list view
  Widget buildHeader(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        alignment: Alignment.centerRight,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => ConstrainedBox(
                  constraints: responsive.phoneScreen ? const BoxConstraints() : const BoxConstraints(maxWidth: 300),
                  child: headerBuilder!(),
                )));
  }

  /// buildListFooter build footer in list view
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  /// _buildCheckItem is a widget builder for each item in check mode
  Widget _buildCheckItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Stack(
      children: [
        _buildItem(context, itemIndex, item, isSelected),
        Positioned(
          top: 30,
          left: 30,
          child: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected
                ? context.themeColor(
                    light: Colors.amber.shade600,
                    dark: Colors.orange.withOpacity(0.5),
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
  Widget _buildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: isSelected
          ? const EdgeInsets.symmetric(vertical: 24, horizontal: 24)
          : const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: isSelected ? 2 : 1,
          color: isSelected
              ? selectedBorderColor ??
                  context.themeColor(
                    light: Colors.amber.shade700,
                    dark: Colors.orange.shade200,
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
