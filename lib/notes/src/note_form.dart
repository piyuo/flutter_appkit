import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/net/net.dart' as net;
import 'package:reactive_forms/reactive_forms.dart';

import 'note_form_controller.dart';

/// NoteForm is form to edit item with [NoteFormController]
class NoteForm<T extends net.Object> extends StatelessWidget {
  const NoteForm({
    required this.formController,
    super.key,
    this.showSubmitButton = true,
    this.onWillPop,
  });

  /// showSubmitButton is true mean show submit button
  final bool showSubmitButton;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  /// onWillPop provides a way to intercept the back button
  // ignore: deprecated_member_use
  final void Function(FormGroup, bool)? onWillPop;

  @override
  Widget build(BuildContext context) {
    if (formController.formState == NotesFormState.formEmpty) {
      return const SizedBox();
    }

    if (formController.formState == NotesFormState.formNotExists) {
      return const delta.NoDataDisplay();
    }

    return form.ShimmerForm(
        showShimmer: formController.formState == NotesFormState.loading,
        formGroup: formController.formGroup,
        onWillPop: onWillPop,
        child: Column(
          children: [
            formController.buildForm(context),
            if (showSubmitButton)
              Padding(
                padding: const EdgeInsets.all(20),
                child: form.Submit(
                  onSubmit: formController.onSubmit,
                ),
              )
          ],
        ));
  }
}
