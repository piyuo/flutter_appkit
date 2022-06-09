import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// ItemBuilder build item to display
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, bool isSelected);

/// ItemDecorationBuilder build item decoration when selected or checked
typedef ItemDecorationBuilder<T> = Widget Function(
  BuildContext context, {
  required Widget child,
  required bool checkMode,
  required bool isSelected,
});

abstract class Selectable<T> extends StatelessWidget {
  const Selectable({
    required this.items,
    required this.selectedItems,
    required this.itemBuilder,
    required this.itemDecorationBuilder,
    this.checkMode = false,
    this.onItemTapped,
    this.onItemSelected,
    this.onItemChecked,
    this.headerBuilder,
    this.footerBuilder,
    this.creating,
    this.isReady = true,
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

  /// itemDecorationBuilder is a item decoration builder
  final ItemDecorationBuilder<T> itemDecorationBuilder;

  /// onItemTapped is callback when item is tapped
  final void Function(T item)? onItemTapped;

  /// onItemSelected is callback when item is selected
  final void Function(List<T> items)? onItemSelected;

  /// onItemChecked is callback when item is checked
  final void Function(List<T> items)? onItemChecked;

  /// headerBuilder build header widget
  final Widget Function()? headerBuilder;

  /// footerBuilder build footer widget
  final Widget Function()? footerBuilder;

  /// creating is not null mean user is editing a new item
  final T? creating;

  /// isReadyToShow is true mean list is ready to show
  final bool isReady;

  /// _buildItemWithDecoration build item with decoration
  Widget _buildItemWithDecoration(BuildContext context, T item, bool isSelected) => itemDecorationBuilder(
        context,
        child: itemBuilder(context, item, isSelected),
        checkMode: checkMode,
        isSelected: isSelected,
      );

  /// buildItem is build item by itemIndex
  Widget buildItem(BuildContext context, T item) {
    var isSelected = false;
    if (creating != null && item == creating) {
      isSelected = true;
    } else if (creating == null && selectedItems.contains(item)) {
      isSelected = true;
    }
    if (onItemSelected != null || onItemChecked != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!checkMode) {
            onItemTapped?.call(item);
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
        child: _buildItemWithDecoration(context, item, isSelected),
      );
    }
    return _buildItemWithDecoration(context, item, isSelected);
  }
}

/// defaultListDecorationBuilder build default list decoration
Widget defaultListDecorationBuilder(
  BuildContext context, {
  required Widget child,
  required bool checkMode,
  required bool isSelected,
}) {
  final selectableItem = Padding(
      padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
      child: isSelected
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(9)),
                color: context.themeColor(
                  light: Colors.blue.shade200,
                  dark: Colors.blueAccent.shade400.withOpacity(0.8),
                ),
              ),
              child: child,
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
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

  if (checkMode) {
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
        Expanded(child: selectableItem),
      ],
    );
  }
  return selectableItem;
}

/// defaultGridDecorationBuilder build default grid decoration
Widget defaultGridDecorationBuilder(
  BuildContext context, {
  required Widget child,
  required bool checkMode,
  required bool isSelected,
}) {
  final selectableItem = Container(
    width: double.infinity,
    height: double.infinity,
    margin: isSelected ? const EdgeInsets.fromLTRB(4, 5, 4, 9) : const EdgeInsets.fromLTRB(5, 6, 5, 10),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: context.themeColor(light: Colors.white, dark: Colors.grey.shade800),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(
        width: isSelected ? 2 : 1,
        color: isSelected
            ? context.themeColor(
                light: Colors.blue.shade700,
                dark: Colors.blueAccent.shade200,
              )
            : context.themeColor(
                light: Colors.grey.shade400,
                dark: Colors.grey.shade700,
              ),
      ),
    ),
    child: child,
  );

  if (checkMode) {
    return Stack(
      children: [
        selectableItem,
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
  return selectableItem;
}
