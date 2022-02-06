import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

class ButtonPanel<T> extends StatelessWidget {
  /// ButtonPanel show list of button to click
  ///
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
    this.checkedValue,
    this.foregroundColor,
    this.backgroundColor,
    this.checkColor,
  }) : super(key: key);

  /// foregroundColor is the color of the text
  final Color? foregroundColor;

  /// backgroundColor is the color of the background
  final Color? backgroundColor;

  /// checkColor is the check color
  final Color? checkColor;

  /// children is the list of buttons
  final Map<T, Widget> children;

  /// checkedValue is the value of button should check
  final List<T>? checkedValue;

  /// onPressed is the callback when a button is pressed
  final void Function(T value) onPressed;

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
          primary: backgroundColor ?? context.themeColor(light: Colors.white, dark: Colors.grey.shade800),
          onPrimary: foregroundColor ?? context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade200),
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          elevation: 0,
        ),
        label: children.values.elementAt(i),
        icon: Icon(Icons.check, color: checkColor ?? Colors.amber.shade700),
        onPressed: () => onPressed(children.entries.elementAt(i).key),
      ));
      if (i < children.entries.length - 1) result.add(const Divider(height: 1));
    }

    return Column(
      children: result,
    );
  }
}
