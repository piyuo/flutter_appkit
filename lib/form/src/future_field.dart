import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FutureField run future when pressed
class FutureField<T> extends ReactiveFormField<T, T> {
  /// FutureField run future when pressed
  /// ```dart
  /// FutureField<String>(
  ///  onPressed: (String? text) async {
  ///    return 'ax';
  ///  },
  ///  valueBuilder: (String? value) => value != null ? Text(value) : const SizedBox(),
  ///  formControlName: 'future',
  ///  decoration: const InputDecoration(
  ///    labelText: 'future name',
  ///    hintText: 'please input future name',
  ///  ),
  ///  validationMessages: (control) => {
  ///    ValidationMessage.required: 'The name must not be empty',
  ///  },
  /// ),
  /// ```
  FutureField({
    Future<T?> Function(BuildContext context, T? value)? onPressed,
    required Widget Function(T?) valueBuilder,
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    ShowErrorsFunction? super.showErrors,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
          builder: (ReactiveFormFieldState<T, T> field) {
            Widget suffixIcon = Icon(
              Icons.navigate_next,
              color: onPressed == null ? Colors.grey.shade400 : null,
            );

            final effectiveDecoration = decoration
                .applyDefaults(
                  Theme.of(field.context).inputDecorationTheme,
                )
                .copyWith(suffixIcon: suffixIcon);

            return IgnorePointer(
              ignoring: !field.control.enabled,
              child: GestureDetector(
                  onTap: onPressed != null
                      ? () async {
                          final value = await onPressed(field.context, field.value);
                          field.control.markAsTouched();
                          field.didChange(value);
                        }
                      : null,
                  child: InputDecorator(
                    decoration: effectiveDecoration.copyWith(
                      errorText: field.errorText,
                      enabled: field.control.enabled && onPressed != null,
                    ),
                    isEmpty: field.value == null,
                    child: valueBuilder(field.value),
                  )),
            );
          },
        );
}
