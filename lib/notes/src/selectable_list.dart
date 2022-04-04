import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'selectable.dart';

abstract class SelectableList<T> extends Selectable<T> {
  const SelectableList({
    required List<T> items,
    required List<T> selectedItems,
    bool checkMode = false,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    this.selectedColor,
    required ItemBuilder<T> itemBuilder,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
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

  /// selectedColor is a color for selected item
  final Color? selectedColor;

  @override
  Widget onBuildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return checkMode
        ? _buildCheckItem(context, itemIndex, item, isSelected)
        : _buildItem(context, itemIndex, item, isSelected);
  }

  /// buildListHeader build header in list view
  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 5),
      child: headerBuilder!(),
    );
  }

  /// buildListFooter build footer in list view
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  /// buildCheckListItem is a widget builder for each item in check mode
  Widget _buildCheckItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Row(
      children: [
        Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected
              ? context.themeColor(
                  light: Colors.amber.shade600,
                  dark: Colors.orange.withOpacity(0.8),
                )
              : context.themeColor(
                  light: Colors.grey.shade300,
                  dark: Colors.grey.shade800,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildItem(context, itemIndex, item, isSelected)),
      ],
    );
  }

  /// buildListItem build list view item
  Widget _buildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return isSelected
        ? Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(9)),
              color: selectedColor ??
                  context.themeColor(
                    light: Colors.amber.shade200,
                    dark: Colors.orange.shade300.withOpacity(0.8),
                  ),
            ),
            child: itemBuilder(item, isSelected),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 9, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemBuilder(item, isSelected),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.themeColor(
                    light: Colors.grey.shade200,
                    dark: Colors.grey.shade800,
                  ),
                ),
              ],
            ));
  }
}
