import 'package:flutter/material.dart';
import 'grid_list.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// SelectableList is a list that selectable
/// ```dart
/// SelectableList<String>(
///   items: const ['a', 'b', 'c', 'd', 'e'],
///   selectedItems: const ['b'],
///   builder: (String item, bool isSelected) => Padding(
///     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
///     child: Text(item),
///   ),
/// )
/// ```
class SelectableList<T> extends GridList<T> {
  /// SelectableList is a list that selectable
  /// ```dart
  /// SelectableList<String>(
  ///   items: const ['a', 'b', 'c', 'd', 'e'],
  ///   selectedItems: const ['b'],
  ///   builder: (String item, bool isSelected) => Padding(
  ///     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  ///     child: Text(item),
  ///   ),
  /// )
  /// ```
  const SelectableList({
    required List<T> items,
    required List<T> selectedItems,
    required this.builder,
    this.checkMode = false,
    this.selectedColor,
    final Future<void> Function()? onRefresh,
    final Future<void> Function()? onLoadMore,
    Widget Function()? headerBuilder,
    Widget Function()? footerBuilder,
    void Function(List<T> items)? onItemSelected,
    void Function(List<T> items)? onItemChecked,
    Key? key,
  }) : super(
          items: items,
          selectedItems: selectedItems,
          multiSelect: checkMode,
          onRefresh: onRefresh,
          onLoadMore: onLoadMore,
          headerBuilder: headerBuilder,
          footerBuilder: footerBuilder,
          onItemSelected: onItemSelected,
          onItemChecked: onItemChecked,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          key: key,
        );

  /// builder is a widget builder for each item
  final ItemBuilder<T> builder;

  /// checkMode is a boolean value that indicates whether the list is in check mode
  final bool checkMode;

  /// selectedColor is a color for selected item
  final Color? selectedColor;

  /// buildHeader build header
  @override
  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: headerBuilder!(),
    );
  }

  /// buildFooter build footer
  @override
  Widget buildFooter(BuildContext context) {
    return footerBuilder!();
  }

  @override
  Widget buildItem(BuildContext context, int itemIndex, T item, bool isSelected) {
    return checkMode
        ? buildCheckable(context, itemIndex, item, isSelected)
        : buildSelectable(context, itemIndex, item, isSelected);
  }

  /// buildCheckable is a widget builder for each item in check mode
  Widget buildCheckable(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Padding(
        padding: const EdgeInsets.only(left: 5), // 2 is bottom separator
        child: Row(
          children: [
            Icon(
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
            const SizedBox(width: 15),
            Expanded(child: buildSelectable(context, itemIndex, item, isSelected)),
          ],
        ));
  }

  /// buildSelectable is a widget builder for each item in select mode
  Widget buildSelectable(BuildContext context, int itemIndex, T item, bool isSelected) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: isSelected
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                  color: selectedColor ??
                      context.themeColor(
                        light: Colors.amber.shade200,
                        dark: Colors.orange.shade300.withOpacity(0.5),
                      ),
                ),
                child: builder(item, isSelected),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    builder(item, isSelected),
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
