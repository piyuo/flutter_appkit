import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'field.dart';

enum DateFieldMode { time, date, datetime }

/// DateField for input date
class DateField extends Field<DateTime> {
  const DateField({
    required Key key,
    required ValueNotifier<DateTime?> controller,
    this.firstDate,
    this.lastDate,
    String? label,
    bool requiredField = false,
    FormFieldValidator<DateTime>? validator,
    this.mode = DateFieldMode.date,
    FocusNode? focusNode,
  }) : super(
          key: key,
          controller: controller,
          label: label,
          requiredField: requiredField,
          validator: validator,
          focusNode: focusNode,
        );

  /// firstDate define first date
  final DateTime? firstDate;

  /// lastDate define last date
  final DateTime? lastDate;

  final DateFieldMode mode;

  DateTimeFieldPickerMode get _mode {
    switch (mode) {
      case DateFieldMode.time:
        return DateTimeFieldPickerMode.time;
      case DateFieldMode.date:
        return DateTimeFieldPickerMode.date;
      case DateFieldMode.datetime:
        return DateTimeFieldPickerMode.dateAndTime;
    }
  }

  DateFormat get _format {
    switch (mode) {
      case DateFieldMode.time:
        return i18n.timeFormat;
      case DateFieldMode.date:
        return i18n.dateFormat;
      case DateFieldMode.datetime:
        return i18n.dateTimeFormat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      mode: _mode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dateFormat: _format,
      initialValue: controller.value,
      firstDate: firstDate,
      lastDate: lastDate,
      validator: (value) => super.validate(context, value),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(
          Icons.expand_more,
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
