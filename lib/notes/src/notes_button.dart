import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_controller.dart';
import 'master_detail_view.dart';

class NotesButton<T extends pb.Object> extends StatelessWidget {
  const NotesButton({
    required this.controller,
    this.deleteLabel,
    this.deleteIcon,
    Key? key,
  }) : super(key: key);

  /// controller is the [NotesController]
  final NotesController<T> controller;

  /// deleteLabel is the label for delete button
  final String? deleteLabel;

  /// deleteIcon is the icon for delete button
  final IconData? deleteIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: () async {
        final action = await responsive.showToolMenu<MasterDetailViewAction>(
          context,
          items: [
            responsive.ToolButton<MasterDetailViewAction>(
              label: context.i18n.refreshButtonText,
              icon: Icons.refresh,
              value: MasterDetailViewAction.refresh,
            ),
            responsive.ToolButton<MasterDetailViewAction>(
              label: controller.isListView ? context.i18n.notesViewAsGridLabel : context.i18n.notesViewAsListLabel,
              icon: controller.isListView ? Icons.grid_view : Icons.view_headline,
              value: controller.isListView ? MasterDetailViewAction.gridView : MasterDetailViewAction.listView,
            ),
            responsive.ToolButton<MasterDetailViewAction>(
              label:
                  controller.isCheckMode ? context.i18n.notesDeselectButtonLabel : context.i18n.notesSelectButtonLabel,
              icon: controller.isCheckMode ? Icons.circle_outlined : Icons.check_circle_outline,
              value: MasterDetailViewAction.toggleCheckMode,
            ),
            if (deleteLabel != null)
              responsive.ToolButton<MasterDetailViewAction>(
                label: context.i18n.notesDeleteButtonLabel,
                icon: deleteIcon ?? Icons.delete,
                value: MasterDetailViewAction.delete,
              ),
            responsive.ToolSpacer(),
            responsive.ToolButton<MasterDetailViewAction>(
              label: context.i18n.notesNewButtonLabel,
              icon: Icons.add,
              value: MasterDetailViewAction.add,
            ),
          ],
        );

        if (action != null) {
          controller.onBarAction(context, action);
        }
      },
    );
  }
}
