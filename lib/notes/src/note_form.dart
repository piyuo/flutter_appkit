import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'note_form_controller.dart';

/// NoteForm is form to edit item with [NoteFormController]
class NoteForm<T extends pb.Object> extends StatelessWidget {
  const NoteForm({
    required this.formController,
    Key? key,
    this.showSubmitButton = true,
  }) : super(key: key);

  /// showSubmitButton is true mean show submit button
  final bool showSubmitButton;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  @override
  Widget build(BuildContext context) {
    if (formController.isEmpty) {
      if (formController.shimmerBuilder != null) {
        return formController.shimmerBuilder!(context);
      }
      return const delta.LoadingDisplay(showAnimation: true);
    }
    return ReactiveForm(
        formGroup: formController.formGroup,
        child: Column(
          children: [
            formController.buildForm(context),
            if (showSubmitButton)
              Padding(
                padding: const EdgeInsets.all(20),
                child: form.Submit(
                  label: 'Submit',
                  onPressed: () => formController.onSubmit(context),
                ),
              )
          ],
        ));
  }
}
