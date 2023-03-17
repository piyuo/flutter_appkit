import 'package:flutter/material.dart';
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
    this.onWillPop,
  }) : super(key: key);

  /// showSubmitButton is true mean show submit button
  final bool showSubmitButton;

  /// formController is form controller, don't direct consume it, this provider maybe inhibit by other provider
  final NoteFormController<T> formController;

  /// onWillPop provides a way to intercept the back button
  final WillPopCallback? onWillPop;

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
