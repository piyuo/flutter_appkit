import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
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
      onRefresh: onRefresh,
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
    this.onRefresh,
  }) : super(key: key);

  final Map<T, String> items;

  final ValueNotifier<T> controller;

  final String? title;

  final Future<Map<T, String>> Function(BuildContext context)? onRefresh;

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
        actions: widget.onRefresh != null
            ? [
                IconButton(
                  tooltip: 'refresh'.i18n_,
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    final result = await widget.onRefresh!(context);
                    setState(() {
                      widget.items.clear();
                      widget.items.addAll(result);
                    });
                  },
                ),
              ]
            : null,
      ),
      body: SafeArea(
          right: false,
          bottom: false,
          child: delta.Listing<T>(
            selectedTileColor: Colors.blue,
            selectedFontColor: Colors.white,
            controller: widget.controller,
            items: widget.items.entries.map((entry) => delta.ListingItem(entry.key, text: entry.value)).toList(),
            onItemTap: (BuildContext context, T value) {
              Navigator.pop(context, value);
            },
          )),
    );
  }
}
