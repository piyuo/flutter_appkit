import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_provider.dart';
import 'note_form_controller.dart';

/// NotesViewMenuButton is menu button for notes view
class NotesViewMenuButton<T extends pb.Object> extends StatelessWidget {
  const NotesViewMenuButton({
    this.tools,
    Key? key,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotesProvider<T>, NoteFormController<T>>(
        builder: (context, provide, formController, _) => IconButton(
              icon: const Icon(Icons.pending_outlined),
              onPressed: provide.isReady
                  ? () => responsive.showToolSheet(
                        context,
                        items: [
                          responsive.ToolButton(
                            label: context.i18n.refreshButtonText,
                            icon: Icons.refresh,
                            onPressed: () => provide.refresh(context),
                          ),
                          if (provide.hasListView && provide.hasGridView)
                            responsive.ToolButton(
                              label: provide.isListView
                                  ? context.i18n.notesViewAsGridLabel
                                  : context.i18n.notesViewAsListLabel,
                              icon: provide.isListView ? Icons.grid_view : Icons.view_headline,
                              onPressed: provide.isListView ? provide.onGridView : provide.onListView,
                            ),
                          responsive.ToolButton(
                            label: provide.isCheckMode
                                ? context.i18n.notesDeselectButtonLabel
                                : context.i18n.notesSelectButtonLabel,
                            icon: provide.isCheckMode ? Icons.circle_outlined : Icons.check_circle_outline,
                            onPressed: provide.onToggleCheckMode,
                          ),
                          if (formController.showArchiveButton)
                            responsive.ToolButton(
                              label: context.i18n.archiveButtonText,
                              icon: Icons.archive,
                              onPressed: provide.isNotEmpty ? () => provide.onArchive(context) : null,
                            ),
                          if (formController.showDeleteButton)
                            responsive.ToolButton(
                              label: context.i18n.deleteButtonText,
                              icon: Icons.delete,
                              onPressed: provide.isNotEmpty ? () => provide.onDelete(context) : null,
                            ),
                          if (formController.showRestoreButton)
                            responsive.ToolButton(
                              label: context.i18n.restoreButtonText,
                              icon: Icons.restore,
                              onPressed: provide.isNotEmpty ? () => provide.onRestore(context) : null,
                            ),
                          responsive.ToolSpacer(),
                          if (tools != null) ...tools!,
                          responsive.ToolButton(
                            label: context.i18n.notesNewButtonLabel,
                            icon: Icons.add,
                            onPressed: () => provide.onAdd(context),
                          ),
                        ],
                      )
                  : null,
            ));
  }
}
