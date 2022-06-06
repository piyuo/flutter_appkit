import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'note_form_controller.dart';

/// NoteFormMenuButton is menu button for note
class NoteFormMenuButton<T extends pb.Object> extends StatelessWidget {
  const NoteFormMenuButton({
    required this.formController,
    Key? key,
    this.tools,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: formController.isEmpty
          ? null
          : () => responsive.showToolSheet(
                context,
                items: [
                  if (formController.showArchiveButton)
                    responsive.ToolButton(
                      label: context.i18n.archiveButtonText,
                      icon: Icons.archive,
                      onPressed: () => formController.archive(context, [formController.current!]),
                    ),
                  if (formController.showDeleteButton)
                    responsive.ToolButton(
                      label: context.i18n.deleteButtonText,
                      icon: Icons.delete,
                      onPressed: () => formController.delete(context, [formController.current!]),
                    ),
                  if (formController.showRestoreButton)
                    responsive.ToolButton(
                      label: context.i18n.restoreButtonText,
                      icon: Icons.restore,
                      onPressed: () => formController.restore(context, [formController.current!]),
                    ),
                  responsive.ToolSpacer(),
                  if (tools != null) ...tools!,
                  responsive.ToolButton(
                    label: context.i18n.saveButtonText,
                    icon: Icons.save,
                    onPressed: () => formController.submit(context),
                  ),
                ],
              ),
    );
  }
}
//controller.isDirty ? () => controller.save(context) : null