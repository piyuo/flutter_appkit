import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:reactive_forms/reactive_forms.dart';

/// From creates and instance of [ReactiveForm]  and support shimmer
///
/// The [formGroup] and [child] arguments are required.
class ShimmerForm extends StatelessWidget {
  /// From creates and instance of [ReactiveForm]  and support shimmer
  ///
  /// The [formGroup] and [child] arguments are required.
  const ShimmerForm({
    super.key,
    required this.formGroup,
    required this.child,
    this.onWillPop,
    this.showShimmer = false,
  });

  /// child is the form widget
  final Widget child;

  /// formGroup is the form group
  final FormGroup formGroup;

  /// showShimmer is true will show shimmer
  final bool showShimmer;

  /// onWillPop enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  // ignore: deprecated_member_use
  final void Function(FormGroup, bool)? onWillPop;

  @override
  Widget build(BuildContext context) {
    return delta.ShimmerScope(
      enabled: showShimmer,
      child: ReactiveForm(
        formGroup: formGroup,
        onPopInvoked: onWillPop,
        child: child,
      ),
    );
  }
}
