import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'tools.dart';

/// showToolMenu show tool sheet, let user choose item easily on mobile phone device
///
///  ```dart
/// final value = await showToolMenu<String>(
///       context,
///       items: [
///         ToolButton(
///           label: 'New File',
///           icon: Icons.new_label,
///           value: 'new_file',
///         ),
///     ],
///     );
///  ```
Future<T?> showToolMenu<T>(
  BuildContext context, {
  required List<ToolItem<T>> items,
  Color? color,
  Color? activeColor,
  Color? iconColor,
  BoxConstraints constraints = const BoxConstraints(maxWidth: 450),
  double initHeight = 0.7,
  double maxHeight = 0.92,
}) async {
  return await dialog.showSlideSheet<T>(
    context,
    padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
    constraints: constraints,
    initHeight: initHeight,
    maxHeight: maxHeight,
    color: context.themeColor(light: Colors.grey.shade50, dark: Colors.grey.shade900),
    children: items.map((item) => _buildSheetItem(context, item)).toList(),
  );
}

Widget _buildSheetItem<T>(
  BuildContext context,
  ToolItem<T> item,
) {
  if (item is ToolButton<T>) {
    return Padding(
        padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            primary: context.themeColor(light: Colors.white, dark: Colors.grey.shade800),
            onPrimary: context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade200),
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            elevation: 0,
          ),
          child: Row(children: [
            Expanded(
              child: Text(item.text ?? item.label, style: const TextStyle(fontSize: 18)),
            ),
            Icon(item.icon, size: 28),
          ]),
          onPressed: () => item.value != null ? Navigator.pop(context, item.value!) : null,
        ));
  }

  if (item is ToolSelection<T>) {
    return item.selection == null
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      item.label,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    )),
                delta.ButtonPanel<T>(
                  checkedValues: item.value != null ? [item.value!] : null,
                  onPressed: (value) => Navigator.pop(context, value),
                  children: item.selection!.map((T key, String value) {
                    return MapEntry<T, Widget>(
                        key,
                        Row(children: [
                          Expanded(
                            child: Text(value, style: const TextStyle(fontSize: 18)),
                          ),
                          Icon(item.icon),
                        ]));
                  }),
                )
              ],
            ));
  }

  if (item is ToolSpacer<T>) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
      child: const Divider(),
    );
  }

  assert(false, '$item is not implement in _buildSheetItem');
  return const SizedBox();
}
