import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/layout/layout.dart' as layout;
import 'package:libcli/i18n/i18n.dart' as i18n;
import '../src/route.dart';

/// showCheckList show a check list dialog
///
Future<void> showCheckList<T>(
  BuildContext context, {
  required List<layout.ListItem<T>> items,
  Future<void> Function(List<T>)? onDelete,
  Future<List<layout.ListItem<T>>> Function()? onRefresh,
  Future<void> Function()? onNewItem,
  Future<void> Function(T)? onItemTap,
  String? title,
  Widget? hint,
}) async {
  await routeOrDialog<T>(
    context,
    CheckListDialog(
      items: ValueNotifier<List<layout.ListItem<T>>>(items),
      title: title,
      onDelete: onDelete,
      onNewItem: onNewItem,
      onRefresh: onRefresh,
      onItemTap: onItemTap,
      hint: hint,
      selection: ValueNotifier<List<T>>([]),
    ),
  );
}

class CheckListDialog<T> extends StatelessWidget {
  const CheckListDialog({
    required this.items,
    required this.selection,
    this.onNewItem,
    this.onDelete,
    this.onRefresh,
    this.title,
    this.hint,
    this.selectedTileColor,
    this.selectedFontColor,
    this.dividerColor,
    this.checkboxColor,
    this.fontColor,
    this.onItemTap,
    this.itemBuilder,
    Key? key,
  }) : super(key: key);

  /// items keep all list item
  final ValueNotifier<List<layout.ListItem<T>>> items;

  /// selection keep selected item keys
  final ValueNotifier<List<T>> selection;

  final String? title;

  /// onNew happen when user click new button
  final Future<void> Function()? onNewItem;

  /// onDelete happen when user select items to delete
  final Future<void> Function(List<T>)? onDelete;

  /// onRefresh refresh items list
  final Future<List<layout.ListItem<T>>> Function()? onRefresh;

  /// onItemTap happen when user tap a item
  final Future<void> Function(T)? onItemTap;

  /// checkColor is checkbox color
  final Color? checkboxColor;

  /// selectedTileColor is item tile selected color
  final Color? selectedTileColor;

  /// selectedFontColor is item font selected color
  final Color? selectedFontColor;

  /// fontColor is font default color
  final Color? fontColor;

  /// dividerColor set divider with color in each ListTile
  final Color? dividerColor;

  /// hint will show when items is empty
  final Widget? hint;

  /// itemBuilder build custom item widget
  final layout.ListItemBuilder<T, layout.ListItem>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: items,
          ),
          ChangeNotifierProvider.value(value: selection),
        ],
        child:
            Consumer2<ValueNotifier<List<layout.ListItem<T>>>, ValueNotifier<List<T>>>(builder: (context, _, __, ___) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: title != null ? Text(title!) : null,
              actions: <Widget>[
                if (onDelete != null && selection.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        context.i18n.deleteButtonText,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await onDelete!(selection.value);
                        if (onRefresh != null) {
                          items.value = await onRefresh!();
                        }
                        selection.value = [];
                      },
                    ),
                  )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: context.i18n.addButtonText,
              onPressed: onNewItem == null
                  ? null
                  : () async {
                      await onNewItem!();
                      if (onRefresh != null) {
                        items.value = await onRefresh!();
                      }
                    },
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
                right: false,
                bottom: false,
                child: items.value.isEmpty && hint != null
                    ? InkWell(
                        child: hint!,
                        onTap: () async {
                          await onNewItem!();
                          if (onRefresh != null) {
                            items.value = await onRefresh!();
                          }
                        },
                      )
                    : layout.CheckList<T>(
                        itemBuilder: itemBuilder,
                        selectedTileColor: selectedTileColor,
                        selectedFontColor: selectedFontColor,
                        dividerColor: dividerColor,
                        checkboxColor: checkboxColor,
                        fontColor: fontColor,
                        controller: selection,
                        items: items.value,
                        onItemTap: onItemTap == null
                            ? null
                            : (T value) async {
                                await onItemTap!(value);
                                if (onRefresh != null) {
                                  items.value = await onRefresh!();
                                }
                              },
                      )),
          );
        }));
  }
}
