import 'package:flutter/material.dart';
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'note_form_controller.dart';

/// NoteFormMenuButton is menu button for note
class NoteFormMenuButton<T extends pb.Object> extends StatelessWidget {
  const NoteFormMenuButton({
    required this.formController,
    Key? key,
    this.items,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<tools.ToolItem>? items;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pending_outlined),
      onPressed: formController.current == null
          ? null
          : () => tools.showToolSheet(
                context,
                items: [
                  if (formController.showDeleteButton)
                    tools.ToolButton(
                      label: context.i18n.deleteButtonText,
                      icon: Icons.delete,
                      onPressed: formController.isAllowDelete ? () => formController.delete(context) : null,
                    ),
                  if (formController.showRestoreButton)
                    tools.ToolButton(
                      label: context.i18n.restoreButtonText,
                      icon: Icons.restore,
                      onPressed: formController.isAllowDelete
                          ? () => formController.restore(context, [formController.current!])
                          : null,
                    ),
                  tools.ToolSpacer(),
                  if (items != null) ...items!,
                  tools.ToolButton(
                    label: context.i18n.formSubmitButtonText,
                    icon: Icons.cloud_upload,
                    onPressed: () => formController.submit(context),
                  ),
                ],
              ),
    );
  }
}
//controller.isDirty ? () => controller.save(context) : null