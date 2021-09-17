import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'field.dart';

/// DateField for input date
class DateField extends Field {
  const DateField({
    required Key key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.minLength = 0,
    this.maxLength = 256,
    this.formatters,
    this.decoration,
    String? label,
    String? hint,
    String? require,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          require: require,
          validator: validator,
          focusNode: focusNode,
        );

  /// controller is input value controller
  final TextEditingController controller;

  /// textInputAction control keyboard text input action
  final TextInputAction? textInputAction;

  /// maxLength specified max input length
  final int maxLength;

  /// maxLength specified min input length
  final int minLength;

  /// decoration use for custom decoration
  final InputDecoration? decoration;

  final List<TextInputFormatter>? formatters;

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  String? defaultValidator(String? text) {
    var result = super.defaultValidator(text);
    if (result != null) {
      return result;
    }
    if (text!.length < minLength) {
      return 'minLength'
          .i18n_
          .replaceAll('%1', label ?? '')
          .replaceAll('%2', '$minLength')
          .replaceAll('%3', '${text.length}');
    }
    if (text.length > maxLength) {
      return 'maxLength'
          .i18n_
          .replaceAll('%1', label ?? '')
          .replaceAll('%2', '$maxLength')
          .replaceAll('%3', '${text.length}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dateLabelText: '日期',
      timeLabelText: "Hour",
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }

        return true;
      },
      onChanged: (val) => print(val),
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );

    return TextFormField(
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength), ...formatters ?? []],
      textInputAction: textInputAction,
      validator: defaultValidator,
      decoration: decoration ?? defaultDecoration,
    );
  }
}
