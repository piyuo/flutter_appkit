import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'tools.dart';

const _buttonMoreWidth = 50;

/// Toolbar show button and selection on bar, show menu if bar is not long enough
/// ```dart
/// Toolbar(
///  items: [
///    ToolButton(
///      label: 'New File',
///      icon: Icons.new_label,
///      onPressed: () => debugPrint('new_file pressed'),
///      space: 10,
///    ),
///  ],
///),
/// ```
class Toolbar extends StatelessWidget {
  /// Toolbar show button and selection on bar, show menu if bar is not long enough
  /// ```dart
  /// Toolbar(
  ///  items: [
  ///    ToolButton(
  ///      label: 'New File',
  ///      icon: Icons.new_label,
  ///      onPressed: () => debugPrint('new_file pressed'),
  ///      space: 10,
  ///    ),
  ///  ],
  ///),
  /// ```
  const Toolbar({
    required this.items,
    this.color,
    this.activeColor,
    this.iconColor,
    this.mainAxisAlignment = MainAxisAlignment.start,
    Key? key,
  }) : super(key: key);

  /// children contain tool item need show on toolbar
  final List<ToolItem> items;

  /// color of toolbar
  final Color? color;

  /// activeColor is color of active item
  final Color? activeColor;

  /// iconColor is color of icon
  final Color? iconColor;

  /// mainAxisAlignment is toolbar main axis alignment
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth - _buttonMoreWidth;
        var barItems = <ToolItem>[];
        var menuItems = <ToolItem>[];
        double width = 0;
        for (ToolItem item in items) {
          width += item.width + (item.space ?? 0);
          if (width > maxWidth) {
            menuItems.add(item);
          } else {
            barItems.add(item);
          }
        }

        final buttons = barItems.map((item) => _buildItemOnBar(context, item, activeColor)).toList();
        if (menuItems.isNotEmpty) {
          var popItems = <PopupMenuEntry>[];
          for (int i = 0; i < menuItems.length; i++) {
            ToolItem item = menuItems[i];
            popItems.addAll(_buildItemOnMenu(context, item, i == 0, i == menuItems.length - 1));
          }

          buttons.add(
            PopupMenuButton(
              icon: Icon(
                Icons.keyboard_double_arrow_right,
                color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
              ),
              offset: const Offset(0, 45),
              itemBuilder: (context) => popItems,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              //onSelected: onPressed != null ? (value) => onPressed!(value) : null,
            ),
          );
        }
        return Container(
            color: color,
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: buttons,
            ));
      },
    );
  }
}

/// _buildItemOnBar build item widget on bar
Widget _buildItemOnBar(
  BuildContext context,
  ToolItem item,
  Color? activeColor,
) {
  if (item is ToolSpacer) {
    return const Spacer();
  }

  final color = context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400);
  if (item is ToolButton) {
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
        onPressed: item.onPressed != null ? () => item.onPressed!() : null,
        tooltip: item.label,
      ),
    );
  }

  if (item is ToolSelection) {
    return Container(
        margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
        width: item.width,
        child: delta.MenuButton(
          padding: EdgeInsets.zero,
          color: color,
          icon: item.icon != null ? Icon(item.icon!) : null,
          label: item.text != null ? Text(item.text!, style: TextStyle(color: color)) : null,
          onPressed: item.onPressed,
          selectedValue: item.selectedValue,
          selection: item.selection,
        ));
  }

  assert(false, '$item is not implement in _buildBarItem');
  return const SizedBox();
}

/// _buildMenuItem build menu item for toolbar popup menu
List<PopupMenuEntry> _buildItemOnMenu(
  BuildContext context,
  ToolItem item,
  bool first,
  bool last,
) {
  if (item is ToolSpacer) {
    return [const PopupMenuDivider()];
  }

  final color = context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade300);
  if (item is ToolButton) {
    return [
      PopupMenuItem(
          enabled: item.onPressed != null,
          onTap: item.onPressed,
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

  if (item is ToolSelection) {
    return [
      if (!first) const PopupMenuDivider(),
      PopupMenuItem(
        value: item.selectedValue,
        enabled: false,
        child: Text(item.label),
      ),
      ...item.selection.entries.map((entry) {
        return PopupMenuItem(
          value: entry.key,
          onTap: item.onPressed != null ? () => item.onPressed!(entry.key) : null,
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: item.selectedValue == entry.key ? const Icon(Icons.check, size: 18) : null,
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
