import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/responsive/responsive.dart' as responsive;

class SelectionHeader extends StatelessWidget {
  /// SelectionHeader is a widget that displays the title and actions of the selection
  const SelectionHeader({
    required this.selected,
    this.isAllSelected = false,
    this.onSelectAll,
    this.onUnselectAll,
    this.actions,
    this.showCheckbox = true,
    Key? key,
  }) : super(key: key);

  final int selected;

  final bool isAllSelected;

  final VoidCallback? onSelectAll;

  final VoidCallback? onUnselectAll;

  final List<Widget>? actions;

  final bool showCheckbox;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Container(
            color: Colors.yellow.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                if (showCheckbox)
                  IconButton(
                    icon: Icon(
                      isAllSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: Colors.white,
                    ),
                    onPressed: isAllSelected ? onUnselectAll : onSelectAll,
                  ),
                if (selected > 0)
                  Text(context.i18n.notesItemSelectedLabel.replace1(selected.toString()),
                      style: const TextStyle(fontSize: 16, color: Colors.white), maxLines: 1),
                if (selected == 0)
                  TextButton(
                    child: Text(context.i18n.notesSelectAllButtonLabel,
                        style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                    onPressed: onSelectAll,
                  ),
                if (selected > 0 && responsive.isNotPhoneDesign)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      child: Text(context.i18n.notesUnselectAllButtonLabel,
                          style: TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                      onPressed: onUnselectAll,
                    ),
                  ),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            )));
  }
}
