import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'field.dart';

/// DateField for input date
class DateField extends Field {
  const DateField({
    required Key key,
    required this.controller,
    this.firstDate,
    this.lastDate,
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
  final ValueNotifier<DateTime?> controller;

  /// firstDate define first date
  final DateTime? firstDate;

  /// lastDate define last date
  final DateTime? lastDate;

  @override
  bool isEmpty() => controller.value == null;

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: i18n.datePattern,
      initialValue: controller.value != null ? i18n.formatDate(controller.value!.toLocal()) : '',
      firstDate: firstDate ?? DateTime(1951),
      lastDate: lastDate ?? DateTime(2050),
      dateLabelText: label,
      validator: defaultValidator,
      autovalidate: true,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      /*
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        //if (date.weekday == 6 || date.weekday == 7) {
        //  return false;
        //}

        return true;
      },*/
      onChanged: (val) {
        controller.value = DateFormat('yyyy-MM-dd', null).parse(val).toUtc();
        debugPrint(val);
      },
    );
  }
}
