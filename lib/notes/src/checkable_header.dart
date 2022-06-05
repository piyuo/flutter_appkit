import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// CheckableHeader is a widget that displays the title and actions of the selection
/// ```dart
/// const CheckableHeader(
///   selectedItemCount: 3,
///   isAllSelected: true,
/// ),
/// ```
class CheckableHeader extends StatelessWidget {
  /// CheckableHeader is a widget that displays the title and actions of the selection
  /// ```dart
  /// const CheckableHeader(
  ///   selectedItemCount: 3,
  ///   isAllSelected: true,
  /// ),
  /// ```
  const CheckableHeader({
    required this.selectedItemCount,
    this.isAllSelected = false,
    this.onSelectAll,
    this.onUnselectAll,
    this.actions,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  /// selectedItemCount is the number of selected items
  final int selectedItemCount;

  /// isAllSelected is true if all items are selected
  final bool isAllSelected;

  /// actions is widgets to do other action
  final List<Widget>? actions;

  /// onUnselectAll is callback when user click select all
  final VoidCallback? onSelectAll;

  /// onUnselectAll is callback when user click unselect all
  final VoidCallback? onUnselectAll;

  /// onCancel is callback when user click cancel
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Container(
            color: Colors.blue.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isAllSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: Colors.white,
                  ),
                  onPressed: isAllSelected ? onUnselectAll : onSelectAll,
                ),
                Text(context.i18n.notesItemSelectedLabel.replace1(selectedItemCount.toString()),
                    style: const TextStyle(fontSize: 16, color: Colors.white), maxLines: 1),
                TextButton(
                  child: Text(context.i18n.closeButtonText,
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade300)),
                  onPressed: onCancel,
                ),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            )));
  }
}
