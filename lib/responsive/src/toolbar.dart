import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'tools.dart';

const _buttonMoreWidth = 60;

/// Toolbar show button and selection on bar, show menu if bar is not long enough
/// ```dart
/// Toolbar<String>(
///  onPressed: (index) => debugPrint('just press $index'),
///  items: [
///    ToolButton(
///      label: 'New File',
///      icon: Icons.new_label,
///      value: 'new_file',
///      space: 10,
///    ),
///  ],
///),
/// ```
class Toolbar<T> extends StatelessWidget {
  /// Toolbar show button and selection on bar, show menu if bar is not long enough
  /// ```dart
  /// Toolbar<String>(
  ///  onPressed: (index) => debugPrint('just press $index'),
  ///  items: [
  ///    ToolButton(
  ///      label: 'New File',
  ///      icon: Icons.new_label,
  ///      value: 'new_file',
  ///      space: 10,
  ///    ),
  ///  ],
  ///),
  /// ```
  const Toolbar({
    required this.items,
    required this.onPressed,
    this.color,
    this.activeColor,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  /// children contain tool item need show on toolbar
  final List<ToolItem<T>> items;

  /// onPressed callback when user click on item
  final ToolCallback<T> onPressed;

  /// color of toolbar
  final Color? color;

  /// activeColor is color of active item
  final Color? activeColor;

  /// iconColor is color of icon
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth - _buttonMoreWidth;
        var barItems = <ToolItem<T>>[];
        var menuItems = <ToolItem<T>>[];
        double width = 0;
        for (ToolItem<T> item in items) {
          width += item.width;
          if (item.space != null) {
            width += item.space!;
          }
          if (width > maxWidth) {
            menuItems.add(item);
          } else {
            barItems.add(item);
          }
        }

        final buttons = barItems.map((item) => _buildBarItem(context, item, onPressed, activeColor)).toList();
        if (menuItems.isNotEmpty) {
          var popItems = <PopupMenuEntry<T>>[];
          for (int i = 0; i < menuItems.length; i++) {
            ToolItem<T> item = menuItems[i];
            popItems.addAll(_buildMenuItem(context, item, i == 0, i == menuItems.length - 1));
          }

          buttons.add(
            PopupMenuButton<T>(
              icon: Icon(
                Icons.keyboard_double_arrow_right,
                color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
              ),
              offset: const Offset(0, 45),
              itemBuilder: (context) => popItems,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onSelected: (value) {
                onPressed(value);
              },
            ),
          );
        }
        return Container(
            color: color,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: buttons,
            ));
      },
    );
  }
}

Widget _buildBarItem<T>(
  BuildContext context,
  ToolItem<T> item,
  ToolCallback<T> callback,
  Color? activeColor,
) {
  if (item is ToolSpacer<T>) {
    return const Spacer();
  }

  final color = context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400);
  if (item is ToolButton<T>) {
    return Container(
      margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
      width: item.width,
      decoration: BoxDecoration(
          color: item.active
              ? activeColor ??
                  context.themeColor(
                    light: Colors.grey.shade200,
                    dark: Colors.grey.shade800,
                  )
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: IconButton(
        color: color,
        icon: item.text != null
            ? Text(item.text!, style: TextStyle(color: color))
            : item.icon != null
                ? Icon(item.icon!)
                : Text(item.label, style: TextStyle(color: color)),
        onPressed: item.value != null ? () => callback(item.value!) : null,
        tooltip: item.label,
      ),
    );
  }

  if (item is ToolSelection<T>) {
    return Container(
        margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
        width: item.width,
        child: delta.MenuButton<T>(
          padding: EdgeInsets.zero,
          color: color,
          icon: item.icon != null ? Icon(item.icon!) : null,
          label: item.text != null ? Text(item.text!, style: TextStyle(color: color)) : null,
          onPressed: item.selection != null ? (value) => callback(value) : null,
          selectedValue: item.value,
          selection: item.selection != null ? item.selection! : {},
        ));
  }

  assert(false, '$item is not implement in _buildBarItem');
  return const SizedBox();
}

/// _buildMenuItem build menu item for toolbar popup menu
List<PopupMenuEntry<T>> _buildMenuItem<T>(
  BuildContext context,
  ToolItem<T> item,
  bool first,
  bool last,
) {
  if (item is ToolSpacer<T>) {
    return [const PopupMenuDivider()];
  }

  final color = context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade300);
  if (item is ToolButton<T>) {
    return [
      PopupMenuItem(
          value: item.value,
          enabled: item.value != null,
          child: Row(
            children: [
              Icon(
                item.icon,
                color: color,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(item.text ?? item.label, style: TextStyle(color: color))
            ],
          ))
    ];
  }

  if (item is ToolSelection<T>) {
    return [
      if (!first) const PopupMenuDivider(),
      PopupMenuItem(
        value: item.value,
        child: Text(item.label),
        enabled: false,
      ),
      if (item.selection != null)
        ...item.selection!.entries.map((entry) {
          return PopupMenuItem<T>(
            value: entry.key,
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: item.value == entry.key ? const Icon(Icons.check, size: 18) : null,
                ),
                Text(entry.value),
              ],
            ),
          );
        }).toList(),
      if (!last) const PopupMenuDivider()
    ];
  }

  assert(false, '$item is not implement in _buildMenuItem');
  return [];
}
