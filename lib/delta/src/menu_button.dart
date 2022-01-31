import 'package:flutter/material.dart';

class MenuButton<T> extends StatelessWidget {
  const MenuButton({
    required this.icon,
    required this.onPressed,
    required this.selection,
    this.tooltip,
    this.checkedValue,
    this.color,
    Key? key,
  }) : super(key: key);

  final Icon icon;

  final void Function(T value) onPressed;

  final Map<T, String> selection;

  final String? tooltip;

  final T? checkedValue;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: icon,
          onPressed: () => onPress(context),
          tooltip: tooltip,
          color: color,
        ),
        GestureDetector(
            onTap: () => onPress(context),
            child: Icon(
              Icons.arrow_drop_down,
              color: color,
              size: 20,
            )),
      ],
    );
  }

  Future<void> onPress(BuildContext context) async {
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
    final value = await showMenu(
      context: context,
      position: position,
      items: selection.entries
          .map(
            (entry) => PopupMenuItem(
                value: entry.key,
                child: Row(
                  children: [
                    if (checkedValue != null)
                      SizedBox(
                        width: 32,
                        child: checkedValue == entry.key ? const Icon(Icons.check, size: 18) : null,
                      ),
                    Text(entry.value),
                  ],
                )),
          )
          .toList(),
    );
    if (value != null) {
      onPressed(value);
    }
  }
}
