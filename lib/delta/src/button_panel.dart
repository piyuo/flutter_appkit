import 'package:flutter/material.dart';

/// ButtonPanel show list of button to click
class ButtonPanel<T> extends StatelessWidget {
  /// ```dart
  /// ButtonPanel<String>(
  ///        onPressed: (item) => debugPrint('$item pressed'),
  ///     children: {
  ///       '0': Row(children: const [
  ///         Expanded(
  ///           child: Text('button', style: TextStyle(fontSize: 18)),
  ///         ),
  ///         Icon(Icons.add),
  ///       ]),
  ///     },
  ///   )
  /// ```
  const ButtonPanel({
    Key? key,
    required this.children,
    required this.onPressed,
    this.checkedValues,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  /// children is the list of buttons
  final Map<T, Widget> children;

  /// checkedValue is the value of button should check
  final List<T>? checkedValues;

  /// onPressed is the callback when a button is pressed
  final void Function(T value) onPressed;

  bool isItemChecked(T value) => checkedValues != null && checkedValues!.contains(value);

  final Color? foregroundColor;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < children.entries.length; i++) {
      result.add(ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: i == 0 ? const Radius.circular(15) : Radius.zero,
            topRight: i == 0 ? const Radius.circular(15) : Radius.zero,
            bottomLeft: i == children.entries.length - 1 ? const Radius.circular(15) : Radius.zero,
            bottomRight: i == children.entries.length - 1 ? const Radius.circular(15) : Radius.zero,
          )),
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          elevation: 0,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        ),
        label: children.values.elementAt(i),
        icon: checkedValues != null
            ? isItemChecked(children.entries.elementAt(i).key)
                ? Icon(Icons.check, color: Theme.of(context).colorScheme.secondary)
                : const SizedBox(width: 24)
            : const SizedBox(),
        onPressed: () => onPressed(children.entries.elementAt(i).key),
      ));
      if (i < children.entries.length - 1) result.add(const Divider(height: 1));
    }

    return Column(
      children: result,
    );
  }
}
