import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'tools.dart';

const buttonMoreWidth = 60;

class Toolbar<T> extends StatelessWidget {
  /// Toolbar show button and selection on bar, show menu if bar is not long enough
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

  final ToolCallback<T> onPressed;

  final Color? color;

  final Color? activeColor;

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth - buttonMoreWidth;
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
          buttons.add(IconButton(
            color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
            icon: const Icon(Icons.navigate_next),
            onPressed: () async {
              var popItems = <PopupMenuEntry>[];
              for (int i = 0; i < menuItems.length; i++) {
                ToolItem<T> item = menuItems[i];
                popItems.addAll(_buildMenuItem(context, item, i == 0, i == menuItems.length - 1));
              }
              final result = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(constraints.maxWidth - buttonMoreWidth, 0, 0, 0),
                items: popItems,
              );
              if (result != null) {
                onPressed(result!);
              }
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ));
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
        onPressed: () => callback(item.value!),
        tooltip: item.label,
      ),
    );
  }

  if (item is ToolSelection<T>) {
    return Container(
        margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
        width: item.width,
        child: delta.MenuButton<T>(
          color: color,
          icon: item.text != null
              ? Text(item.text!, style: TextStyle(color: color))
              : item.icon != null
                  ? Icon(item.icon!)
                  : Text(item.label, style: TextStyle(color: color)),
          onPressed: (value) => callback(value),
          checkedValue: item.checkedValue,
          selection: item.selection,
          tooltip: item.label,
        ));
  }

  assert(false, '$item is not implement in _buildBarItem');
  return const SizedBox();
}

/// _buildMenuItem build menu item for toolbar popup menu
List<PopupMenuEntry> _buildMenuItem<T>(
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
      ...item.selection.entries.map((entry) {
        return PopupMenuItem<T>(
          value: entry.key,
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: item.checkedValue == entry.key ? const Icon(Icons.check, size: 18) : null,
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
