import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'note_controller.dart';

/// NoteContainer show item detail view with [NoteController]
class NoteContainer<T extends pb.Object> extends StatelessWidget {
  const NoteContainer({
    this.isRemoveButtonVisible = true,
    Key? key,
  }) : super(key: key);

  final bool isRemoveButtonVisible;

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteController<T>>(builder: (context, controller, _) {
      if (controller.current == null) {
        if (controller.shimmerBuilder != null) {
          return controller.shimmerBuilder!(context);
        }
        return const delta.LoadingDisplay(showAnimation: true);
      }
      return Form(
          key: controller.formKey,
          child: Column(
            children: [
              controller.contentBuilder(controller.current!),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: form.Submit(
                    key: const Key('submit'),
                    label: 'Submit',
                    onPressed: controller.isDirty
                        ? () async {
                            await controller.save(context);
                            controller.onSaved?.call();
                          }
                        : null),
              )
            ],
          ));
    });
  }
}
