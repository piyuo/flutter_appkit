import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'menu_button.dart';
import 'button_panel.dart';

/// ToolItem define item in toolbar
abstract class ToolItem {
  /// ToolItem define item in toolbar
  ToolItem({required this.width, this.space});

  /// width of item, every item must specify width in order to calculate toolbar width
  final double width;

  /// space between item
  double? space;
}

/// ToolControl define control item in toolbar
abstract class ToolControl extends ToolItem {
  /// ToolControl define control item in toolbar
  ToolControl({
    required this.label,
    required double width,
    double? space,
    this.text,
    this.icon,
  }) : super(width: width, space: space);

  /// text display value of control, display icon if text is null
  final String? text;

  /// icon of control, display label if text is null
  final IconData? icon;

  /// label of control
  final String label;
}

/// ToolButton define button item in toolbar
/// ```dart
/// ToolButton(
///   label: 'New File',
///   icon: Icons.new_label,
///   value: 'new_file',
///   space: 10,
///  ),
/// ```
class ToolButton extends ToolControl {
  /// ToolButton define button item in toolbar
  /// ```dart
  /// ToolButton(
  ///   label: 'New File',
  ///   icon: Icons.new_label,
  ///   value: 'new_file',
  ///   space: 10,
  ///  ),
  /// ```
  ToolButton({
    double width = 38,
    double? space,
    required String label,
    this.onPressed,
    String? text,
    IconData? icon,
    this.active = false,
  }) : super(width: width, label: label, space: space, text: text, icon: icon);

  final bool active;

  /// onPressed called when user press button
  final VoidCallback? onPressed;
}

/// ToolSelection define item in toolbar
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
class ToolSelection extends ToolControl {
  /// ToolSelection define item in toolbar
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
    double width = 60,
    double? space,
    required String label,
    required this.selection,
    this.onPressed,
    this.selectedValue,
    String? text,
    IconData? icon,
  }) : super(width: width, label: label, icon: icon, space: space, text: text);

  final Map<dynamic, String> selection;

  /// onPressed called when user press button
  final void Function(dynamic value)? onPressed;

  /// selectedValue is selection selected value
  dynamic selectedValue;
}

/// ToolSpacer show expanded space on toolbar
/// ```dart
/// ToolSpacer(),
/// ```
class ToolSpacer extends ToolItem {
  /// ToolSpacer show expanded space on toolbar
  /// ```dart
  /// ToolSpacer(),
  /// ```
  ToolSpacer({
    double space = 0,
  }) : super(width: 0, space: space);
}

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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              offset: const Offset(0, 45),
              itemBuilder: (context) => popItems,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              //onSelected: onPressed != null ? (value) => onPressed!(value) : null,
            ),
          );
        }
        return Container(
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
  final colorScheme = Theme.of(context).colorScheme;
  if (item is ToolButton) {
    return Container(
      margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
      width: item.width,
      decoration: BoxDecoration(
          color: item.active ? activeColor ?? colorScheme.secondary : null,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: IconButton(
        icon: item.text != null
            ? Text(item.text!)
            : item.icon != null
                ? Icon(item.icon!,
                    color: item.active
                        ? colorScheme.onSecondary
                        : colorScheme.onSurfaceVariant.withOpacity(item.onPressed != null ? 1 : .5))
                : Text(item.label, style: TextStyle(color: item.active ? colorScheme.onSecondary : null)),
        onPressed: item.onPressed != null ? () => item.onPressed!() : null,
        tooltip: item.label,
      ),
    );
  }

  if (item is ToolSelection) {
    return Container(
        margin: item.space != null ? EdgeInsets.only(right: item.space!) : null,
        width: item.width,
        child: MenuButton(
          padding: EdgeInsets.zero,
          icon: item.icon != null
              ? Icon(item.icon!, color: colorScheme.onSurface.withOpacity(item.onPressed != null ? 1 : .5))
              : null,
          label: item.text != null
              ? Text(item.text!,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(item.onPressed != null ? 1 : .5)))
              : null,
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

  if (item is ToolButton) {
    return [
      PopupMenuItem(
          enabled: item.onPressed != null,
          onTap: item.onPressed,
          child: Row(
            children: [
              Icon(item.icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 9),
              Text(item.text ?? item.label)
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
    itemBuilder: (context, index) {
      final item = items[index];
      Widget? widget;
      if (item is ToolButton) {
        widget = ListTile(
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
            ButtonPanel(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
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
