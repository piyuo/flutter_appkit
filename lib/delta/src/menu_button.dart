import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// MenuButton displays a button with a menu to show
/// ```dart
/// MenuButton<String>(
/// icon: const Icon(Icons.settings),
/// label: const Text('Settings'),
/// onPressed: (value) {
///   debugPrint('$value pressed');
/// },
/// selectedValue: '2',
/// selection: const {
///   '1': 'hello',
///   '2': 'world',
/// }),
/// ```
class MenuButton<T> extends StatelessWidget {
  /// MenuButton displays a button with a menu to show
  /// ```dart
  /// MenuButton<String>(
  /// icon: const Icon(Icons.settings),
  /// label: const Text('Settings'),
  /// onPressed: (value) {
  ///   debugPrint('$value pressed');
  /// },
  /// selectedValue: '2',
  /// selection: const {
  ///   '1': 'hello',
  ///   '2': 'world',
  /// }),
  /// ```
  const MenuButton({
    required this.onPressed,
    required this.selection,
    this.icon,
    this.label,
    this.selectedValue,
    this.color,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    Key? key,
  }) : super(key: key);

  /// icon is button icon
  final Widget? icon;

  /// label is button label
  final Widget? label;

  /// onPressed called when button pressed
  final void Function(T value)? onPressed;

  /// selection is a map of values to display
  final Map<T, String> selection;

  /// selectedValue will be checked when show selection
  final T? selectedValue;

  /// color is button color
  final Color? color;

  /// padding is button padding
  final EdgeInsetsGeometry? padding;

  /// mainAxisAlignment is button mainAxisAlignment
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = color ?? context.themeColor(light: Colors.grey.shade800, dark: Colors.grey.shade200);
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: foregroundColor,
        padding: padding,
      ),
      label: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          label ?? const SizedBox(),
          Icon(
            Icons.arrow_drop_down,
            color: onPressed != null ? foregroundColor : Colors.grey,
            size: 20,
          ),
        ],
      ),
      icon: icon ?? const SizedBox(),
      onPressed: onPressed != null
          ? () async {
              assert(selection.isNotEmpty, 'selection must not be empty');
              // This offset should depend on the largest text and this is tricky when
              // the menu items are changed
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset.zero, ancestor: overlay),
                  button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                ),
                Offset(0, -button.size.height) & overlay.size,
              );
              final _value = await showMenu(
                context: context,
                position: position,
                items: selection.entries
                    .map(
                      (entry) => PopupMenuItem(
                          value: entry.key,
                          child: Row(
                            children: [
                              if (selectedValue != null)
                                SizedBox(
                                  width: 32,
                                  child: selectedValue == entry.key ? const Icon(Icons.check, size: 18) : null,
                                ),
                              Text(entry.value),
                            ],
                          )),
                    )
                    .toList(),
              );
              if (_value != null) {
                onPressed?.call(_value);
              }
            }
          : null,
    );
  }
}
