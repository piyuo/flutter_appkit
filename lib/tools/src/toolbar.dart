import 'package:flutter/material.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

/// ToolItem define item in toolbar
abstract class ToolItem {
  /// ToolItem define item in toolbar
  ToolItem({required this.width, this.space});

  /// width of item, every item must specify width in order to calculate toolbar width
  final double width;

  /// space between item
  double? space;

  /// barBuild build item on toolbar
  Widget barBuild(BuildContext context);

  /// sheetBuild build item on sheet
  Widget sheetBuild(BuildContext context);

  /// menuBuild build item on menu
  List<PopupMenuEntry> menuBuild(BuildContext context, bool first, bool last);
}

/// ToolControl define control item in toolbar
abstract class ToolControl extends ToolItem {
  ToolControl({
    required this.label,
    required double width,
    double? space,
    this.icon,
  }) : super(width: width, space: space);

  /// icon of control
  final IconData? icon;

  /// label of control
  final String label;
}

const _buttonMoreWidth = 50;

/// Toolbar show button and selection on bar, show menu if bar is not long enough
class Toolbar extends StatelessWidget {
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

        final buttons = barItems.map((item) => item.barBuild(context)).toList();
        if (menuItems.isNotEmpty) {
          var popItems = <PopupMenuEntry>[];
          for (int i = 0; i < menuItems.length; i++) {
            ToolItem item = menuItems[i];
            popItems.addAll(item.menuBuild(context, i == 0, i == menuItems.length - 1));
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
      return Padding(
        padding: EdgeInsets.only(top: 15, bottom: item.space != null ? item.space! : 0),
        child: item.sheetBuild(context),
      );
    },
  );
}
