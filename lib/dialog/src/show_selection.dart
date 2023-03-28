import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'dialog.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// showSingleSelection show a string select dialog
Future<T?> showSingleSelection<T>(
  BuildContext context, {
  required Map<T, String> items,
  String? title,
  Future<Map<T, String>> Function(BuildContext context)? onRefresh,
}) async {
  return await routeOrDialog<T>(
    context,
    SingleSelection(
      items: items,
      title: title,
      controller: ValueNotifier<T?>(null),
    ),
  );
}

class SingleSelection<T> extends StatefulWidget {
  const SingleSelection({
    Key? key,
    required this.items,
    required this.controller,
    this.title,
  }) : super(key: key);

  final Map<T, String> items;

  final ValueNotifier<T> controller;

  final String? title;

  @override
  State<StatefulWidget> createState() => _SingleSelectionState<T>();
}

class _SingleSelectionState<T> extends State<SingleSelection<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.title != null ? Text(widget.title!) : null,
      ),
      body: SafeArea(
          right: false,
          bottom: false,
          child: delta.Listing<T>(
            controller: widget.controller,
            items: widget.items.entries.map((entry) => delta.ListItem(entry.key, title: entry.value)).toList(),
            onItemTap: (BuildContext context, T value) {
              Navigator.pop(context, value);
            },
          )),
    );
  }
}

/// showCheckList show a check list dialog
Future<void> showCheckList<T>(
  BuildContext context, {
  required List<delta.ListItem<T>> items,
  Future<void> Function(List<T>)? onDelete,
  Future<List<delta.ListItem<T>>> Function()? onRefresh,
  Future<void> Function()? onNewItem,
  Future<void> Function(T)? onItemTap,
  String? title,
  Widget? hint,
}) async {
  await routeOrDialog<T>(
    context,
    CheckListDialog(
      items: ValueNotifier<List<delta.ListItem<T>>>(items),
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
    this.onItemTap,
    this.itemBuilder,
    Key? key,
  }) : super(key: key);

  /// items keep all list item
  final ValueNotifier<List<delta.ListItem<T>>> items;

  /// selection keep selected item keys
  final ValueNotifier<List<T>> selection;

  final String? title;

  /// onNew happen when user click new button
  final Future<void> Function()? onNewItem;

  /// onDelete happen when user select items to delete
  final Future<void> Function(List<T>)? onDelete;

  /// onRefresh refresh items list
  final Future<List<delta.ListItem<T>>> Function()? onRefresh;

  /// onItemTap happen when user tap a item
  final Future<void> Function(T)? onItemTap;

  /// hint will show when items is empty
  final Widget? hint;

  /// itemBuilder build custom item widget
  final delta.ListItemBuilder<T, delta.ListItem>? itemBuilder;

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
            Consumer2<ValueNotifier<List<delta.ListItem<T>>>, ValueNotifier<List<T>>>(builder: (context, _, __, ___) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: title != null ? Text(title!) : null,
              actions: <Widget>[
                if (onDelete != null && selection.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text(
                        context.i18n.deleteButtonText,
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
                    : delta.CheckList<T>(
                        itemBuilder: itemBuilder,
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
