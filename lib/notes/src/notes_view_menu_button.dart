import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'notes_view_provider.dart';

class NotesViewMenuButton<T extends pb.Object> extends StatelessWidget {
  const NotesViewMenuButton({
    required this.controller,
    this.tools,
    this.deleteLabel,
    this.deleteIcon,
    Key? key,
  }) : super(key: key);

  /// controller is the [NotesViewProvider]
  final NotesViewProvider<T> controller;

  /// deleteLabel is the label for delete button
  final String? deleteLabel;

  /// deleteIcon is the icon for delete button
  final IconData? deleteIcon;

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
                  if (deleteLabel != null)
                    responsive.ToolButton(
                      label: context.i18n.notesDeleteButtonLabel,
                      icon: deleteIcon ?? Icons.delete,
                      onPressed: () => controller.onDelete(context),
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
