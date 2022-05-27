import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_provider.dart';

/// NotesMenuButton is menu button for notes view
class NotesMenuButton<T extends pb.Object> extends StatelessWidget {
  const NotesMenuButton({
    required this.controller,
    this.tools,
    Key? key,
  }) : super(key: key);

  /// controller is the [NotesProvider]
  final NotesProvider<T> controller;

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: controller.isReady
          ? () async {
              await responsive.showToolSheet(
                context,
                items: [
                  responsive.ToolButton(
                    label: context.i18n.refreshButtonText,
                    icon: Icons.refresh,
                    onPressed: () => controller.refresh(context),
                  ),
                  responsive.ToolButton(
                    label:
                        controller.isListView ? context.i18n.notesViewAsGridLabel : context.i18n.notesViewAsListLabel,
                    icon: controller.isListView ? Icons.grid_view : Icons.view_headline,
                    onPressed: controller.isListView ? controller.onGridView : controller.onListView,
                  ),
                  responsive.ToolButton(
                    label: controller.isCheckMode
                        ? context.i18n.notesDeselectButtonLabel
                        : context.i18n.notesSelectButtonLabel,
                    icon: controller.isCheckMode ? Icons.circle_outlined : Icons.check_circle_outline,
                    onPressed: controller.onToggleCheckMode,
                  ),
                  if (controller.archiveHandler != null)
                    responsive.ToolButton(
                      label: context.i18n.archiveButtonText,
                      icon: Icons.archive,
                      onPressed: () => controller.archive(context),
                    ),
                  if (controller.removeHandler != null)
                    responsive.ToolButton(
                      label: context.i18n.deleteButtonText,
                      icon: Icons.delete,
                      onPressed: () => controller.remove(context),
                    ),
                  responsive.ToolSpacer(),
                  if (tools != null) ...tools!,
                  responsive.ToolButton(
                    label: context.i18n.notesNewButtonLabel,
                    icon: Icons.add,
                    onPressed: () => controller.onAdd(context),
                  ),
                ],
              );
            }
          : null,
    );
  }
}
