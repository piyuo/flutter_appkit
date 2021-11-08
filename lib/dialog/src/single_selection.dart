import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import '../src/route.dart';

/// selection show a string select dialog
///
Future<T?> singleSelection<T>(
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
            selectedTileColor: Colors.blue,
            selectedFontColor: Colors.white,
            dividerColor: context.themeColor(light: Colors.grey[300]!, dark: Colors.grey[800]!),
            controller: widget.controller,
            items: widget.items.entries.map((entry) => delta.ListItem(entry.key, title: entry.value)).toList(),
            onItemTap: (BuildContext context, T value) {
              Navigator.pop(context, value);
            },
          )),
    );
  }
}
