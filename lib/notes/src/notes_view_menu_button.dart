import 'package:flutter/material.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/tools/tools.dart' as tools;
import 'notes_provider.dart';
import 'note_form_controller.dart';

/// NotesViewMenuButton is menu button for notes view
class NotesViewMenuButton<T extends net.Object> extends StatelessWidget {
  const NotesViewMenuButton({
    required this.viewProvider,
    required this.formController,
    this.items,
    super.key,
  });

  /// tools is extra tools for master detail view
  final List<tools.ToolItem>? items;

  /// notesProvider provide notes, don't direct consume it, this provider maybe inhibit by other provider
  final NotesProvider<T> viewProvider;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: viewProvider.isReadyToShow
          ? () => tools.showToolSheet(
                context,
                items: [
                  tools.ToolButton(
                    label: context.i18n.refreshButtonText,
                    icon: Icons.refresh,
                    onPressed: () => viewProvider.refresh(context),
                  ),
                  if (viewProvider.hasListView && viewProvider.hasGridView)
                    tools.ToolButton(
                      label: viewProvider.isListView
                          ? context.i18n.notesViewAsGridLabel
                          : context.i18n.notesViewAsListLabel,
                      icon: viewProvider.isListView ? Icons.grid_view : Icons.view_headline,
                      onPressed: viewProvider.isListView
                          ? () => viewProvider.onGridView(context)
                          : () => viewProvider.onListView(context),
                    ),
                  tools.ToolButton(
                    label: viewProvider.isCheckMode
                        ? context.i18n.notesDeselectButtonLabel
                        : context.i18n.notesSelectButtonLabel,
                    icon: viewProvider.isCheckMode ? Icons.circle_outlined : Icons.check_circle_outline,
                    onPressed: () => viewProvider.onToggleCheckMode(context),
                  ),
                  if (formController.showDeleteButton)
                    tools.ToolButton(
                      label: context.i18n.deleteButtonText,
                      icon: Icons.delete,
                      onPressed: viewProvider.isAllowDelete ? () => viewProvider.onDelete(context) : null,
                      //onPressed: () => dialog.alert(context, 'hello delete',
                      //    buttonYes: true, buttonNo: true, buttonCancel: true, blurry: false),
                    ),
                  if (formController.showRestoreButton)
                    tools.ToolButton(
                      label: context.i18n.restoreButtonText,
                      icon: Icons.restore,
                      onPressed: viewProvider.isAllowDelete ? () => viewProvider.onRestore(context) : null,
                    ),
                  tools.ToolSpacer(),
                  if (items != null) ...items!,
                  tools.ToolButton(
                    label: context.i18n.notesNewButtonLabel,
                    icon: Icons.add,
                    onPressed: () => viewProvider.onCreateNew(context),
                  ),
                  tools.ToolButton(
                    label: context.i18n.formSubmitButtonText,
                    icon: Icons.cloud_upload,
                    onPressed: () => viewProvider.formController.submit(context),
                  ),
                ],
              )
          : null,
    );
  }
}
