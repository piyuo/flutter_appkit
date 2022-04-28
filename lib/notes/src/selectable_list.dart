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
    Color? itemBackgroundColor,
    T? newItem,
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
          itemBackgroundColor: itemBackgroundColor,
          newItem: newItem,
          key: key,
        );

  /// selectedColor is a color for selected item
  final Color? selectedColor;

  @override
  Widget onBuildItem(BuildContext context, T item, bool isSelected) {
    return checkMode ? _buildCheckItem(context, item, isSelected) : _buildItem(context, item, isSelected);
  }

  /// buildCheckListItem is a widget builder for each item in check mode
  Widget _buildCheckItem(BuildContext context, T item, bool isSelected) {
    return Row(
      children: [
        Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected
              ? context.themeColor(
                  light: Colors.blue.shade600,
                  dark: Colors.blueAccent.withOpacity(0.8),
                )
              : context.themeColor(
                  light: Colors.grey.shade300,
                  dark: Colors.grey.shade800,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _buildItem(context, item, isSelected)),
      ],
    );
  }

  /// buildListItem build list view item
  Widget _buildItem(BuildContext context, T item, bool isSelected) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        child: isSelected
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                  color: selectedColor ??
                      context.themeColor(
                        light: Colors.blue.shade200,
                        dark: Colors.blueAccent.shade400.withOpacity(0.8),
                      ),
                ),
                child: itemBuilder(item, isSelected),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
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
                )));
  }
}
