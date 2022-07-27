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
    padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
    maxWidth: maxWidth,
    heightFactor: heightFactor,
    itemCount: items.length,
    itemBuilder: (index) {
      final item = items[index];
      Widget? widget;
      if (item is ToolButton) {
        widget = ListTile(
          tileColor: context.themeColor(light: Colors.white, dark: Colors.grey.shade800),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          enableFeedback: true,
          textColor: item.onPressed == null ? Colors.grey : null,
          iconColor: item.onPressed == null ? Colors.grey : null,
          onTap: item.onPressed != null
              ? () {
                  item.onPressed!();
                  Navigator.pop(context);
                }
              : null,
          title: Text(item.text ?? item.label,
              style: const TextStyle(
                fontSize: 18,
              )),
          trailing: Icon(item.icon, size: 28),
        );
      }

      if (item is ToolSelection) {
        widget = Column(
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
        );
      }

      if (item is ToolSpacer) {
        widget = const Divider();
      }

      return Padding(
        padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
        child: widget,
      );
    },
  );
}
