import 'package:flutter/material.dart';

const buttonMoreWidth = 60;

/// ToolbarCallback define the callback for toolbar button
typedef ToolbarCallback<T> = void Function(T value);

class Toolbar<T> extends StatelessWidget {
  /// Toolbar show button and selection on bar, show menu if bar is not long enough
  const Toolbar({
    required this.items,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  /// children contain tool item need show on toolbar
  final List<ToolItem<T>> items;

  final ToolbarCallback<T> onPressed;

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
          if (width > maxWidth) {
            menuItems.add(item);
          } else {
            barItems.add(item);
          }
        }

        final buttons = barItems.map((item) => item.barWidget(context, onPressed)).toList();
        if (menuItems.isNotEmpty) {
          buttons.add(IconButton(
            icon: const Icon(Icons.double_arrow_rounded),
            onPressed: () {
              var popItems = <PopupMenuEntry>[];
              for (ToolItem<T> item in menuItems) {
                popItems.addAll(item.menuEntry(context));
              }
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(constraints.maxWidth - buttonMoreWidth, 0, 0, 0),
                items: popItems,
              );
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ));
        }
        return Row(children: buttons);
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
  });

  final String? label;

  final IconData? icon;

  final T? value;

  final double width;

  Widget barWidget(BuildContext context, ToolbarCallback<T> callback);

  List<PopupMenuEntry> menuEntry(BuildContext context);
}

class ToolButton<T> extends ToolItem<T> {
  /// ToolButton define item in toolbar
  ToolButton({
    required String label,
    required IconData icon,
    required T value,
    this.active = false,
  }) : super(width: -1, label: label, icon: icon, value: value);

  final bool active;

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: IconButton(
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
    this.selectedValue,
  }) : super(
          width: -1,
          label: label,
          icon: icon,
        );

  final T? selectedValue;

  final Map<T, String> selection;

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback) {
    return DropdownButton<T>(
      value: selectedValue,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_downward),
      onChanged: (T? newValue) {
        if (newValue != null) {
          callback(newValue);
        }
      },
      items: selection.entries.map((e) {
        return DropdownMenuItem<T>(
          value: e.key,
          child: Text(e.value),
        );
      }).toList(),
    );
  }

  @override
  List<PopupMenuEntry> menuEntry(BuildContext context) {
    return [
      PopupMenuItem(
        value: value,
        child: Text(label!),
      ),
      ...selection.entries.map((e) {
        return PopupMenuItem<T>(
          value: e.key,
          child: Text(e.value),
        );
      }).toList()
    ];
  }
}

class ToolSpace<T> extends ToolItem<T> {
  /// ToolSpace define empty space in toolbar
  ToolSpace() : super(width: 0);

  @override
  Widget barWidget(BuildContext context, ToolbarCallback<T> callback) {
    return const Spacer();
  }

  @override
  List<PopupMenuEntry> menuEntry(BuildContext context) => [const PopupMenuDivider()];
}
