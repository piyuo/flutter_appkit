import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/responsive/responsive.dart' as responsive;

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
            color: Colors.yellow.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                if (!isAllSelected)
                  TextButton(
                    child: Text(context.i18n.notesSelectAllButtonLabel,
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                    onPressed: onSelectAll,
                  ),
                if (isAllSelected && responsive.isNotPhoneDesign)
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: TextButton(
                      child: Text(context.i18n.notesUnselectAllButtonLabel,
                          style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                      onPressed: onUnselectAll,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  onPressed: onCancel,
                ),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            )));
  }
}
