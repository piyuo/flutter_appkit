import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'note_form_controller.dart';

/// NoteFormMenuButton is menu button for note
class NoteFormMenuButton<T extends pb.Object> extends StatelessWidget {
  const NoteFormMenuButton({
    Key? key,
    this.tools,
  }) : super(key: key);

  /// tools is extra tools for master detail view
  final List<responsive.ToolItem>? tools;

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteFormController<T>>(
        builder: (context, controller, _) => IconButton(
              icon: const Icon(Icons.pending_outlined),
              onPressed: controller.isEmpty
                  ? null
                  : () => responsive.showToolSheet(
                        context,
                        items: [
                          if (controller.showArchiveButton)
                            responsive.ToolButton(
                              label: context.i18n.archiveButtonText,
                              icon: Icons.archive,
                              onPressed: () => controller.archive(context, [controller.current!]),
                            ),
                          if (controller.showDeleteButton)
                            responsive.ToolButton(
                              label: context.i18n.deleteButtonText,
                              icon: Icons.delete,
                              onPressed: () => controller.delete(context, [controller.current!]),
                            ),
                          if (controller.showRestoreButton)
                            responsive.ToolButton(
                              label: context.i18n.restoreButtonText,
                              icon: Icons.restore,
                              onPressed: () => controller.restore(context, [controller.current!]),
                            ),
                          responsive.ToolSpacer(),
                          if (tools != null) ...tools!,
                          responsive.ToolButton(
                            label: context.i18n.saveButtonText,
                            icon: Icons.save,
                            onPressed: () => controller.submit(context),
                          ),
                        ],
                      ),
            ));
  }
}
//controller.isDirty ? () => controller.save(context) : null