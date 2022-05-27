import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'note_controller.dart';

/// NoteMenuButton is menu button for note
class NoteMenuButton<T extends pb.Object> extends StatelessWidget {
  const NoteMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteController<T>>(builder: (context, controller, _) {
      return IconButton(
        icon: const Icon(Icons.done),
        onPressed: controller.isDirty ? () => controller.save(context) : null,
      );
    });
  }
}
