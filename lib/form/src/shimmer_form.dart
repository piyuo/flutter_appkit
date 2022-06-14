import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// From creates and instance of [ReactiveForm]  and support shimmer
///
/// The [formGroup] and [child] arguments are required.
class ShimmerForm extends StatelessWidget {
  /// From creates and instance of [ReactiveForm]  and support shimmer
  ///
  /// The [formGroup] and [child] arguments are required.
  const ShimmerForm({
    Key? key,
    required this.formGroup,
    required this.child,
    this.onWillPop,
    this.showShimmer = false,
  }) : super(key: key);

  /// child is the form widget
  final Widget child;

  /// formGroup is the form group
  final FormGroup formGroup;

  /// showShimmer is true will show shimmer
  final bool showShimmer;

  /// onWillPop enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  @override
  Widget build(BuildContext context) {
    return delta.ShimmerScope(
      enabled: showShimmer,
      child: ReactiveForm(
        formGroup: formGroup,
        child: child,
        onWillPop: onWillPop,
      ),
    );
  }
}
