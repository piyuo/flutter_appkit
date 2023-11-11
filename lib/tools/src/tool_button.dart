import 'package:flutter/material.dart';
import 'toolbar.dart';

/// ToolButton define button item in toolbar
class ToolButton extends ToolControl {
  /// ```dart
  /// ToolButton(
  ///   label: 'New File',
  ///   icon: Icons.new_label,
  ///   value: 'new_file',
  ///   space: 10,
  ///  ),
  /// ```
  ToolButton({
    super.width = 38,
    super.space,
    required super.label,
    this.onPressed,
    super.icon,
    this.active = false,
  });

  final bool active;

  /// onPressed called when user press button
  final VoidCallback? onPressed;

  @override
  Widget barBuild(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: space != null ? EdgeInsets.only(right: space!) : null,
      width: width,
      decoration: BoxDecoration(
          color: active ? colorScheme.secondary : null, borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: IconButton(
        icon: icon != null
            ? Icon(icon!,
                color: active
                    ? colorScheme.onSecondary
                    : colorScheme.onSurfaceVariant.withOpacity(onPressed != null ? 1 : .5))
            : Text(label, style: TextStyle(color: active ? colorScheme.onSecondary : null)),
        onPressed: onPressed != null ? () => onPressed!() : null,
        tooltip: label,
      ),
    );
  }

  @override
  Widget sheetBuild(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      enableFeedback: true,
      textColor: onPressed == null ? Colors.grey : null,
      iconColor: onPressed == null ? Colors.grey : null,
      onTap: onPressed != null
          ? () {
              onPressed!();
              Navigator.pop(context);
            }
          : null,
      title: Text(label,
          style: const TextStyle(
            fontSize: 18,
          )),
      trailing: Icon(icon, size: 28),
    );
  }

  @override
  List<PopupMenuEntry> menuBuild(BuildContext context, bool first, bool last) {
    return [
      PopupMenuItem(
        enabled: onPressed != null,
        onTap: onPressed,
        child: ListTile(leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant), title: Text(label)),
      )
    ];
  }
}
