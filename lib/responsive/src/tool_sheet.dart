import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'tools.dart';

/// showToolSheet show tool sheet, let user choose item easily on mobile phone device
///
///  ```dart
/// await showToolSheet<String>(
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
Future<void> showToolSheet(
  BuildContext context, {
  required List<ToolItem> items,
  Color? color,
  Color? activeColor,
  Color? iconColor,
  double maxWidth = 600,
  double heightFactor = 0.85,
}) async {
  return await dialog.showSheet(
    context,
    maxWidth: maxWidth,
    heightFactor: heightFactor,
    itemCount: items.length,
    itemBuilder: (index) => _buildItemOnSheet(context, items[index]),
  );
}

/// _buildItemOnSheet build item on sheet
Widget _buildItemOnSheet(
  BuildContext context,
  ToolItem item,
) {
  if (item is ToolButton) {
    return Padding(
        padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            primary: context.themeColor(light: Colors.white, dark: Colors.grey.shade800),
            onPrimary: context.themeColor(light: Colors.grey.shade800, dark: Colors.grey.shade100),
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
          onPressed: item.onPressed != null
              ? () {
                  item.onPressed!();
                  Navigator.pop(context);
                }
              : null,
        ));
  }

  if (item is ToolSelection) {
    return Padding(
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
            delta.ButtonPanel(
              checkedValues: item.selectedValue != null ? [item.selectedValue!] : null,
              onPressed: (value) => Navigator.pop(context, value),
              children: item.selection.map((key, value) {
                return MapEntry(
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

  if (item is ToolSpacer) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
      child: const Divider(),
    );
  }

  assert(false, '$item is not implement in _buildSheetItem');
  return const SizedBox();
}
