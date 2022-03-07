import 'package:flutter/material.dart';

/// MenuButton displays a button with a menu to show
/// ```dart
/// MenuButton<String>(
/// icon: const Icon(Icons.settings),
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
    required this.icon,
    required this.onPressed,
    required this.selection,
    this.tooltip,
    this.selectedValue,
    this.color,
    Key? key,
  }) : super(key: key);

  /// icon is button icon
  final Widget icon;

  /// onPressed called when button pressed
  final void Function(T value)? onPressed;

  /// selection is a map of values to display
  final Map<T, String> selection;

  /// selectedValue will be checked when show selection
  final T? selectedValue;

  /// tooltip is button tooltip
  final String? tooltip;

  /// color is button color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Future<void> _buttonPressed() async {
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

    return Row(
      children: [
        Expanded(
            child: IconButton(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          icon: icon,
          onPressed: onPressed != null ? () => _buttonPressed() : null,
          tooltip: tooltip,
          color: color,
        )),
        GestureDetector(
            onTap: () => onPressed != null ? _buttonPressed() : null,
            child: Icon(
              Icons.arrow_drop_down,
              color: onPressed != null ? color : Colors.grey,
              size: 20,
            )),
      ],
    );
  }
}
