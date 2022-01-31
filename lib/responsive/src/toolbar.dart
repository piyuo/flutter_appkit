import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

const buttonMoreWidth = 60;

/// ToolbarCallback define the callback for toolbar button
typedef ToolbarCallback<T> = void Function(T value);

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

  final ToolbarCallback<T> onPressed;

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
          if (item.marginRight != null) {
            width += item.marginRight!;
          }
          if (width > maxWidth) {
            menuItems.add(item);
          } else {
            barItems.add(item);
          }
        }

        final buttons = barItems.map((item) => item.barWidget(context, onPressed, activeColor)).toList();
        if (menuItems.isNotEmpty) {
          buttons.add(IconButton(
            color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
            icon: const Icon(Icons.navigate_next),
            onPressed: () async {
              var popItems = <PopupMenuEntry>[];
              for (ToolItem<T> item in menuItems) {
                popItems.addAll(item.menuEntry(context));
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

abstract class ToolItem<T> {
  /// ToolItem define item in toolbar
  ToolItem({
    required this.width,
    this.value,
    this.label,
    this.icon,
    this.marginRight,
  });

  final String? label;

  final IconData? icon;

  final T? value;

  final double width;

  Widget barWidget(BuildContext context, ToolbarCallback<T> callback, Color? activeColor);

  List<PopupMenuEntry> menuEntry(BuildContext context);

  double? marginRight;
}

class ToolButton<T> extends ToolItem<T> {
  /// ToolButton define item in toolbar
  ToolButton({
    required String label,
    required IconData icon,
    required T value,
    this.active = false,
    double? marginRight,
  }) : super(width: 38, label: label, icon: icon, value: value, marginRight: marginRight);

  final bool active;

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback, Color? activeColor) {
    return Container(
      margin: marginRight != null ? EdgeInsets.only(right: marginRight!) : null,
      width: width,
      decoration: BoxDecoration(
          color: active
              ? activeColor ??
                  context.themeColor(
                    light: Colors.grey.shade200,
                    dark: Colors.grey.shade800,
                  )
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: IconButton(
        color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
        icon: Icon(icon),
        onPressed: () => callback(value!),
        tooltip: label,
      ),
    );
  }

  @override
  List<PopupMenuEntry> menuEntry(BuildContext context) {
    return [
      PopupMenuItem(
          value: value,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.red,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(label!)
            ],
          ))
    ];
  }
}

class ToolSelection<T> extends ToolItem<T> {
  /// ToolButton define item in toolbar
  ToolSelection({
    required String label,
    required IconData icon,
    required this.selection,
    double? marginRight,
    this.checkedValue,
  }) : super(width: 60, label: label, icon: icon, marginRight: marginRight);

  final T? checkedValue;

  final Map<T, String> selection;

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback, Color? activeColor) {
    return Container(
        margin: marginRight != null ? EdgeInsets.only(right: marginRight!) : null,
        width: width,
        child: delta.MenuButton<T>(
          color: context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400),
          icon: Icon(
            icon,
          ),
          onPressed: (value) => callback(value),
          checkedValue: checkedValue,
          selection: selection,
          tooltip: label,
        ));
  }

  @override
  List<PopupMenuEntry> menuEntry(BuildContext context) {
    return [
      const PopupMenuDivider(),
      PopupMenuItem(
        value: value,
        child: Text(label!),
        enabled: false,
      ),
      ...selection.entries.map((entry) {
        return PopupMenuItem<T>(
          value: entry.key,
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: checkedValue == entry.key ? const Icon(Icons.check, size: 18) : null,
              ),
              Text(entry.value),
            ],
          ),
        );
      }).toList(),
      const PopupMenuDivider()
    ];
  }
}

class ToolSpace<T> extends ToolItem<T> {
  /// ToolSpace define empty space in toolbar
  ToolSpace() : super(width: 0);

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback, Color? activeColor) {
    return const Spacer();
  }

  @override
  List<PopupMenuEntry> menuEntry(BuildContext context) => [const PopupMenuDivider()];
}
