import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

enum CalendarType { single, multi, range }

/// Calendar is a convenience widget that can pick single date or date range or multi date
class Calendar extends ReactiveFormField<List<DateTime>, List<DateTime?>> {
  Calendar({
    CalendarType calendarType = CalendarType.single,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    ShowErrorsFunction? super.showErrors,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    Widget? Function(
            {required DateTime date,
            BoxDecoration? decoration,
            bool? isDisabled,
            bool? isSelected,
            bool? isToday,
            TextStyle? textStyle})?
        dayBuilder,
    super.key,
  }) : super(
          builder: (field) {
            return CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: calendarType == CalendarType.single
                    ? CalendarDatePicker2Type.single
                    : calendarType == CalendarType.multi
                        ? CalendarDatePicker2Type.multi
                        : CalendarDatePicker2Type.range,
                firstDate: firstDate,
                lastDate: lastDate,
                currentDate: currentDate,
                dayBuilder: dayBuilder,
                selectableDayPredicate: (DateTime date) => false,
              ),
              value: field.control.value ?? [],
              onValueChanged: (dates) {
                field.control.markAsTouched();
                field.didChange(dates);
              },
            );
          },
        );
}
