import 'package:flutter/material.dart';
import 'field.dart';
import 'custom_field.dart';

/// RadioGroup for simple radio group control
class RadioGroup<T> extends Field<T> {
  const RadioGroup({
    required ValueNotifier<T?> controller,
    required this.items,
    required Key key,
    String? label,
    bool requiredField = false,
    FormFieldValidator<T>? validator,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          label: label,
          controller: controller,
          requiredField: requiredField,
          validator: validator,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          key: key,
        );

  /// items is items user can select
  final Map<T, String> items;

  @override
  Widget build(BuildContext context) {
    return CustomField<T>(
      label: label,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      controller: controller,
      validator: (T? value) => super.validate(context, value),
      border: InputBorder.none,
      builder: () => Row(
        children: items.entries
            .map((e) => _RadioLabel<T>(
                  label: e.value,
                  value: e.key,
                  groupValue: controller.value,
                  onChanged: (T? value) {
                    controller.value = value;
                  },
                ))
            .toList(),
      ),
    );
  }
}

/// _RadioLabel is radio plus label
///
class _RadioLabel<T> extends StatelessWidget {
  const _RadioLabel({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.size = 24,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Radio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?> onChanged;

  final String? label;

  final double size;

  final TextStyle? textStyle;

  Widget _text(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyText1!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        label!,
        style: textStyle ?? style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      label != null
          ? InkWell(
              onTap: () => onChanged(value),
              child: _text(context),
            )
          : const SizedBox(),
    ]);
  }
}
