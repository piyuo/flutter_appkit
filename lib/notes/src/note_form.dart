import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'note_form_controller.dart';

/// NoteForm is form to edit item with [NoteFormController]
class NoteForm<T extends pb.Object> extends StatelessWidget {
  const NoteForm({
    Key? key,
    this.showSubmitButton = true,
  }) : super(key: key);

  /// showSubmitButton is true mean show submit button
  final bool showSubmitButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteFormController<T>>(builder: (context, controller, _) {
      if (controller.isEmpty) {
        if (controller.shimmerBuilder != null) {
          return controller.shimmerBuilder!(context);
        }
        return const delta.LoadingDisplay(showAnimation: true);
      }
      return ReactiveForm(
          formGroup: controller.formGroup,
          child: Column(
            children: [
              controller.buildForm(context),
              if (showSubmitButton)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: form.Submit(
                    label: 'Submit',
                    onPressed: () => controller.onSubmit(context),
                  ),
                )
            ],
          ));
    });
  }
}
