import 'package:flutter/material.dart';
import 'toolbar.dart';
import 'button_panel.dart';
import 'menu_button.dart';

/// ToolSelection define item in toolbar
class ToolSelection extends ToolControl {
  /// ```dart
  ///  ToolSelection<String>(
  ///   width: 120,
  ///   text: 'page 2 of more',
  ///   label: 'rows per page',
  ///   selection: {
  ///     '10': '10 rows',
  ///     '20': '20 rows',
  ///     '50': '50 rows',
  ///   },
  /// ),
  /// ```
  ToolSelection({
    super.width = 60,
    super.space,
    required super.label,
    required this.selection,
    this.onPressed,
    this.selectedValue,
    super.icon,
  });

  final Map<dynamic, String> selection;

  /// onPressed called when user press button
  final void Function(dynamic value)? onPressed;

  /// selectedValue is selection selected value
  dynamic selectedValue;

  @override
  Widget barBuild(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
        margin: space != null ? EdgeInsets.only(right: space!) : null,
        width: width,
        child: MenuButton(
          padding: EdgeInsets.zero,
          icon: icon != null ? Icon(icon!, color: colorScheme.onSurface.withOpacity(onPressed != null ? 1 : .5)) : null,
          label: Text(label, style: TextStyle(color: colorScheme.onSurface.withOpacity(onPressed != null ? 1 : .5))),
          onPressed: onPressed,
          selectedValue: selectedValue,
          selection: selection,
        ));
  }

  @override
  Widget sheetBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            )),
        ButtonPanel(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          checkedValues: selectedValue != null ? [selectedValue!] : null,
          onPressed: (value) => Navigator.pop(context, value),
          children: selection.map((key, value) {
            return MapEntry(
                key,
                Row(children: [
                  Expanded(
                    child: Text(value, style: const TextStyle(fontSize: 18)),
                  ),
                  Icon(icon),
                ]));
          }),
        )
      ],
    );
  }

  @override
  List<PopupMenuEntry> menuBuild(BuildContext context, bool first, bool last) {
    return [
      if (!first) const PopupMenuDivider(),
      PopupMenuItem(
        value: selectedValue,
        enabled: false,
        child: Text(label),
      ),
      ...selection.entries.map((entry) {
        return PopupMenuItem(
          value: entry.key,
          onTap: onPressed != null ? () => onPressed!(entry.key) : null,
          child: ListTile(
            leading: selectedValue == entry.key ? const Icon(Icons.check, size: 18) : const SizedBox(),
            title: Text(entry.value),
          ),
        );
      }),
      if (!last) const PopupMenuDivider()
    ];
  }
}
