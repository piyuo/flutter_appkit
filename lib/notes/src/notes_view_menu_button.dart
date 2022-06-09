import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_provider.dart';
import 'note_form_controller.dart';

/// NotesViewMenuButton is menu button for notes view
class NotesViewMenuButton<T extends pb.Object> extends StatelessWidget {
  const NotesViewMenuButton({
    required this.viewProvider,
    required this.formController,
    this.tools,
    Key? key,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

  /// notesProvider provide notes, don't direct consume it, this provider maybe inhibit by other provider
  final NotesProvider<T> viewProvider;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: viewProvider.isReadyToShow
          ? () => responsive.showToolSheet(
                context,
                items: [
                  responsive.ToolButton(
                    label: context.i18n.refreshButtonText,
                    icon: Icons.refresh,
                    onPressed: () => viewProvider.refresh(context),
                  ),
                  if (viewProvider.hasListView && viewProvider.hasGridView)
                    responsive.ToolButton(
                      label: viewProvider.isListView
                          ? context.i18n.notesViewAsGridLabel
                          : context.i18n.notesViewAsListLabel,
                      icon: viewProvider.isListView ? Icons.grid_view : Icons.view_headline,
                      onPressed: viewProvider.isListView
                          ? () => viewProvider.onGridView(context)
                          : () => viewProvider.onListView(context),
                    ),
                  responsive.ToolButton(
                    label: viewProvider.isCheckMode
                        ? context.i18n.notesDeselectButtonLabel
                        : context.i18n.notesSelectButtonLabel,
                    icon: viewProvider.isCheckMode ? Icons.circle_outlined : Icons.check_circle_outline,
                    onPressed: () => viewProvider.onToggleCheckMode(context),
                  ),
                  if (formController.showArchiveButton)
                    responsive.ToolButton(
                      label: context.i18n.archiveButtonText,
                      icon: Icons.archive,
                      onPressed: viewProvider.isNotEmpty ? () => viewProvider.onArchive(context) : null,
                    ),
                  if (formController.showDeleteButton)
                    responsive.ToolButton(
                      label: context.i18n.deleteButtonText,
                      icon: Icons.delete,
                      onPressed: viewProvider.isNotEmpty ? () => viewProvider.onDelete(context) : null,
                    ),
                  if (formController.showRestoreButton)
                    responsive.ToolButton(
                      label: context.i18n.restoreButtonText,
                      icon: Icons.restore,
                      onPressed: viewProvider.isNotEmpty ? () => viewProvider.onRestore(context) : null,
                    ),
                  responsive.ToolSpacer(),
                  if (tools != null) ...tools!,
                  responsive.ToolButton(
                    label: context.i18n.notesNewButtonLabel,
                    icon: Icons.add,
                    onPressed: () => viewProvider.onCreateNew(context),
                  ),
                ],
              )
          : null,
    );
  }
}
